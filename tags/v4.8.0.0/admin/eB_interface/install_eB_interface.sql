   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/eB_interface/install_eB_interface.sql-arc   1.8   Jan 03 2019 10:20:18   Chris.Baugh  $
   --       Module Name      : $Workfile:   install_eB_interface.sql  $
   --       Date into PVCS   : $Date:   Jan 03 2019 10:20:18  $
   --       Date fetched Out : $Modtime:   Jan 03 2019 10:19:30  $
   --       PVCS Version     : $Revision:   1.8  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge interface for eB install script.
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --
--start ..\admin\eB_interface\eB_interface.tyh  --RAC the types in this script are already absorbed into main LB installation

SET TERM ON
PROMPT CloseLinearLocation.prc                                                                                                                                                                                                            
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'eB_interface'||'&terminator'||'CloseLinearLocation.prc' run_file 
FROM dual
/
start '&run_file'


SET TERM ON
PROMPT CreateLinearLocation.prc                                                                                                                                                                                                         
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'eB_interface'||'&terminator'||'CreateLinearLocation.prc' run_file 
FROM dual
/
start '&run_file'

SET TERM ON
PROMPT CreateLinearRange.prc                                                                                                                                                                                                            
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'eB_interface'||'&terminator'||'CreateLinearRange.prc' run_file 
FROM dual
/
start '&run_file'

SET TERM ON
PROMPT GetAssetLinearLocations.fnc                                                                                                                                                                                                           
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'eB_interface'||'&terminator'||'GetAssetLinearLocations.fnc' run_file 
FROM dual
/
start '&run_file'

start ..\admin\eB_interface\GetAssetLinearLocationsTab.fnc
SET TERM ON
PROMPT GetAssetLinearLocationsTab.fnc                                                                                                                                                                                                           
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'eB_interface'||'&terminator'||'GetAssetLinearLocationsTab.fnc' run_file 
FROM dual
/
start '&run_file'


SET TERM ON
PROMPT GetLinearElementTypes.prc                                                                                                                                                                                                          
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'eB_interface'||'&terminator'||'GetLinearElementTypes.prc' run_file 
FROM dual
/
start '&run_file'

SET TERM ON
PROMPT GetLinearLocations.fnc                                                                                                                                                                                                          
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'eB_interface'||'&terminator'||'GetLinearLocations.fnc' run_file 
FROM dual
/
start '&run_file'

SET TERM ON
PROMPT GetLinearRanges.fnc                                                                                                                                                                                                            
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'eB_interface'||'&terminator'||'GetLinearRanges.fnc' run_file 
FROM dual
/
start '&run_file'

SET TERM ON
PROMPT GetNetworkElementMeasures.fnc                                                                                                                                                                                                        
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'eB_interface'||'&terminator'||'GetNetworkElementMeasures.fnc' run_file 
FROM dual
/
start '&run_file'

SET TERM ON
PROMPT GetNetworkElements.fnc                                                                                                                                                                                                         
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'eB_interface'||'&terminator'||'GetNetworkElements.fnc' run_file 
FROM dual
/
start '&run_file'

SET TERM ON
PROMPT GetNetworkTypes.fnc                                                                                                                                                                                                          
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'eB_interface'||'&terminator'||'GetNetworkTypes.fnc' run_file 
FROM dual
/
start '&run_file'

SET TERM ON
PROMPT GetXspList.fnc                                                                                                                                                                                                          
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'eB_interface'||'&terminator'||'GetXspList.fnc' run_file 
FROM dual
/
start '&run_file'

SET TERM ON
PROMPT GetNetworkLinearLocations.fnc                                                                                                                                                                                                          
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'eB_interface'||'&terminator'||'GetNetworkLinearLocations.fnc' run_file 
FROM dual
/
start '&run_file'

SET TERM ON
PROMPT GetNetworkLinearLocationsTab.fnc                                                                                                                                                                                                            
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'eB_interface'||'&terminator'||'GetNetworkLinearLocationsTab.fnc' run_file 
FROM dual
/
start '&run_file'

SET TERM ON
PROMPT UpdateLinearLocation.prc                                                                                                                                                                                                         
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'eB_interface'||'&terminator'||'UpdateLinearLocation.prc' run_file 
FROM dual
/
start '&run_file'

SET TERM ON
PROMPT v_network_types.sql                                                                                                                                                                                                      
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'eB_interface'||'&terminator'||'v_network_types.sql' run_file 
FROM dual
/
start '&run_file'

SET TERM ON
PROMPT v_network_elements.sql                                                                                                                                                                                                      
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'eB_interface'||'&terminator'||'v_network_elements.sql' run_file 
FROM dual
/
start '&run_file'

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



