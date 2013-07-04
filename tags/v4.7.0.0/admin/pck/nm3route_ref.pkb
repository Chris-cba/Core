CREATE OR REPLACE PACKAGE BODY nm3route_ref AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3route_ref.pkb-arc   2.2   Jul 04 2013 16:21:12   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3route_ref.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:21:12  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:18  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 1.6
-------------------------------------------------------------------------
--
--   Author : I Turnbull
--
--   nm3route_ref body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here

  --g_body_sccsid is the SCCS ID for the package body
    g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.2  $';

  g_package_name CONSTANT varchar2(30) := 'nm3route_ref';
  
  g_job_id    number := -1;
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
----------------------------------------------------------------------------------------------
--
PROCEDURE set_g_job_id( p_job_id number)
IS
BEGIN
   g_job_id := p_job_id;
END  set_g_job_id;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_g_job_id 
RETURN number
IS
BEGIN
   RETURN NVL(g_job_id, -1);
END get_g_job_id;   
--
----------------------------------------------------------------------------------------------
--
PROCEDURE get_inv_on_route( p_ne_id    nm_elements.ne_id%TYPE
                           ,p_inv_type nm_inv_types.nit_inv_type%TYPE
                           ,p_job_id   number DEFAULT NULL
                          )                           
IS
  CURSOR cs_locations ( c_ne_id    nm_elements.ne_id%TYPE
                      ,c_inv_type nm_inv_types.nit_inv_type%TYPE
                     )
  IS
  SELECT iit_ne_id
      ,nm3pla.get_connected_chunks( iit_ne_id,  c_ne_id  ) pla 
  FROM nm_inv_items
  WHERE iit_ne_id IN ( SELECT 
                              DISTINCT iit_ne_id 
                       FROM ( SELECT 
                                   im.nm_ne_id_in iit_ne_id 
                              FROM nm_members im 
                                 , nm_members rm 
                              WHERE 
                                   rm.nm_ne_id_in = c_ne_id 
                              AND 
                                   rm.nm_ne_id_of = im.nm_ne_id_of 
                              AND 
                                   im.nm_obj_type  = c_inv_type
                              AND
                                  ( (im.nm_begin_mp < NVL(rm.nm_end_mp, im.nm_begin_mp + 1)
                                    AND
                                      NVL(im.nm_end_mp, rm.nm_begin_mp + 1) > rm.nm_begin_mp)
                                    OR
                                      (im.nm_begin_mp = im.nm_end_mp
                                    AND
                                      im.nm_begin_mp BETWEEN rm.nm_begin_mp AND NVL(rm.nm_end_mp, im.nm_begin_mp)))
                                 ) );
  
  l_pl nm_placement;
  l_job_id number;                                   

BEGIN

  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_inv_on_route');

  IF p_job_id IS NULL THEN                      
     l_job_id := nm3net.get_next_nte_id;
  ELSE 
     l_job_id := get_g_job_id;
  END IF;                     
                     
  FOR cs_loc_rec IN cs_locations ( p_ne_id ,p_inv_type) LOOP
  
     FOR i IN 1..cs_loc_rec.pla.placement_count LOOP
     
        l_pl := cs_loc_rec.pla.npa_placement_array(i);

        INSERT INTO nm_nw_temp_extents
           ( nte_job_id 
            ,nte_ne_id_of 
            ,nte_begin_mp 
            ,nte_end_mp 
            ,nte_route_ne_id
           )
        VALUES
           ( l_job_id            
            ,l_pl.pl_ne_id 
            ,l_pl.pl_start 
            ,l_pl.pl_end 
            ,cs_loc_rec.iit_ne_id
           ); 
           
     END LOOP;
     
  END LOOP;                     

  set_g_job_id( l_job_id );      
            

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_inv_on_route');

                   
END get_inv_on_route;
--
-----------------------------------------------------------------------------
--
END nm3route_ref;


/ 

