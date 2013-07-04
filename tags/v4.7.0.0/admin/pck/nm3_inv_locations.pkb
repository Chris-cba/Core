CREATE OR REPLACE PACKAGE BODY NM3_inv_locations AS
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :- 
--
--       sccsid           : @(#)nm3_inv_locations.pkb	1.3 10/20/05 
--       Module Name      : nm3_inv_locations.pkb 
--       Date into SCCS   : 05/10/20 09:17:44 
--       Date fetched Out : 05/10/28 13:32:17  
--       SCCS Version     : 1.3  
--
--   Author : P. Stanton 
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
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
