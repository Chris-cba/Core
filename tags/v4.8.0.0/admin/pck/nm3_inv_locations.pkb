CREATE OR REPLACE PACKAGE BODY NM3_inv_locations AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/nm3_inv_locations.pkb-arc   2.3   May 10 2018 14:00:32   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   nm3_inv_locations.pkb  $
--       Date into SCCS   : $Date:   May 10 2018 14:00:32  $
--       Date fetched Out : $Modtime:   May 10 2018 13:56:10  $
--       SCCS Version     : $Revision:   2.3  $
--
--   Author : P. Stanton 
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
-----------
--constants
-----------
--g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid CONSTANT VARCHAR2(2000) := '$Revision:   2.3  $';
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
---------------------------------------------------------------------------
--
PROCEDURE delete_log_table IS

BEGIN

   DELETE FROM nm_members_all_log;

END delete_log_table;
--
---------------------------------------------------------------------------
-- 
PROCEDURE add_to_log_table(p_nm_ne_id_in nm_members_all.nm_ne_id_in%TYPE,
                           p_nm_ne_id_of nm_members_all.nm_ne_id_of%TYPE,
                           p_nm_type   VARCHAR2
                           ) IS
             
BEGIN

   INSERT INTO nm_members_all_log
   VALUES
   (
    p_nm_ne_id_in,
    p_nm_ne_id_of,
    p_nm_type
   );
   
    
END add_to_log_table;
--
---------------------------------------------------------------------------
--
PROCEDURE update_from_log IS

CURSOR get_inv IS
SELECT distinct(log_nm_ne_id_in) log_nm_ne_id_in FROM nm_members_all_log
WHERE log_nm_type = 'I';

CURSOR get_route IS 
SELECT DISTINCT inv.nm_ne_id_in
FROM  NM_MEMBERS_ALL_LOG nml
     ,NM_MEMBERS_ALL RT
     ,NM_MEMBERS_ALL inv
WHERE nml.log_nm_ne_id_in = rt.nm_ne_id_in
AND   rt.nm_ne_id_of = inv.nm_ne_id_of
AND   nml.log_nm_type = 'G'
AND   rt.nm_type = 'G'
AND   rt.nm_obj_type = 'RT'
AND   inv.nm_type = 'I';

BEGIN

   FOR rec IN get_inv LOOP    

      DELETE FROM nm2_inv_locations_tab 
	  WHERE iit_ne_id = rec.log_nm_ne_id_in;
	  
	  INSERT INTO nm2_inv_locations_tab (SELECT *  
	  		 	             FROM   nm2_inv_locations
	  		 	             WHERE  iit_ne_id = rec.log_nm_ne_id_in);
 
   END LOOP;
--
--
   FOR rec IN get_route LOOP

      DELETE FROM nm2_inv_locations_tab 
	  WHERE iit_ne_id = rec.nm_ne_id_in;
	  
	  INSERT INTO nm2_inv_locations_tab (SELECT *  
	  		 	  	     FROM   nm2_inv_locations
					     WHERE  iit_ne_id = rec.nm_ne_id_in);
 
   END LOOP;

END update_from_log;
--
---------------------------------------------------------------------------
--
END nm3_inv_locations;
/
