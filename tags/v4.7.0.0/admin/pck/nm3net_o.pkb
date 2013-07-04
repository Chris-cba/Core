CREATE OR REPLACE PACKAGE BODY nm3net_o AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3net_o.pkb-arc   2.2   Jul 04 2013 16:19:16   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3net_o.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:19:16  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:18  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 1.9
---------------------------------------------------------------------------
--
--   nm3net_o package: Contains procedures/functions for manipulating
--                     networks that use objects. This package will not be
--                     usable from client tools such as Forms.
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '$Revision:   2.2  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name CONSTANT varchar2(30) := 'nm3net_o';
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
-----------------------------------------------------------------------------
--
FUNCTION get_node_class (p_route_id IN number
                        ,p_node_id IN number
                        ) RETURN nm_node_class IS

  CURSOR c1( c_route_id number,
             c_node_id  number ) IS
    SELECT nnu_ne_id FROM nm_node_usages
    WHERE nnu_no_node_id = c_node_id
    AND NOT EXISTS ( SELECT 'c' FROM nm_members
                     WHERE nm_ne_id_in = c_route_id
                     AND nm_ne_id_of = nnu_ne_id );

  CURSOR c2 ( c_route_id number,
              c_node_id  number,
              c_dir      integer )  IS
    SELECT slk  -- In-line view so that we can order by the column which is a function call without replicating the call
     FROM (SELECT nm_seq_no
                 ,nm3net.get_nsc_seq_no(ne_nt_type,ne_sub_class) nsc_seq_no
                 ,decode( c_dir, -1, nm_end_slk, nm_slk) slk
                 ,nm_cardinality
           FROM nm_members, nm_node_usages, nm_elements
           WHERE nm_ne_id_in = p_route_id
           AND   nm3net.route_direction (nnu_node_type, nm_cardinality) = c_dir
           AND   nm_ne_id_of = ne_id
           AND   nnu_ne_id   = ne_id
           AND   nnu_no_node_id = p_node_id
           AND   rownum = 1
          )
    ORDER BY DECODE(nsc_seq_no
                   ,-1,nm_seq_no
                   ,nsc_seq_no
                   ), nm_seq_no
            ,slk;

            
  retval nm_node_class := nm_node_class( p_route_id, p_node_id, NULL, NULL, NULL);

  l_eslk      number;
  l_sslk      number;
  l_ne_id     number;
  l_c1_found  boolean;
--
BEGIN
--
   nm_debug.proc_end(g_package_name,'get_node_class');
--
   DECLARE
      l_not_a_group_therefore_no_poe EXCEPTION;
   BEGIN
      DECLARE
         l_not_a_group EXCEPTION;
         PRAGMA EXCEPTION_INIT (l_not_a_group,-20001);
         l_p_unit number;
         l_c_unit number;
      BEGIN
         nm3net.get_group_units( p_route_id, l_p_unit, l_c_unit );
      EXCEPTION
         WHEN l_not_a_group
          THEN
            retval.nc_intersecting_road := NULL;
            retval.nc_poe               := 0;
            retval.nc_node_type         := NULL;
            RAISE l_not_a_group_therefore_no_poe;
      END;
--
      OPEN  c1 ( p_route_id, p_node_id );
      FETCH c1 INTO l_ne_id;
      l_c1_found := c1%FOUND;
      CLOSE c1;
--
      IF NOT l_c1_found THEN
    --   This is POE or false node or L/R/S change - No other route at the node.
         retval.nc_intersecting_road := NULL;
         retval.nc_node_type := 'F';
      ELSE
    --   This is a true intersection, check the route offsets and test if it is also a POE
         retval.nc_intersecting_road := nm3net.get_ne_descr( l_ne_id );
         retval.nc_node_type := 'I';
      END IF;

      open c2(p_route_id, p_node_id, -1);
      fetch c2 into l_eslk;
      if c2%notfound then
        null;
      end if;
      close c2;
      
      open c2(p_route_id, p_node_id, 1);
      fetch c2 into l_sslk;
      if c2%notfound then
        null;
      end if;
      close c2;
       
      retval.nc_poe := l_sslk - l_eslk;
      
      if l_sslk is null or l_eslk is null then
        retval.nc_poe := 0;
        retval.nc_node_type := 'T';
      end if;

  EXCEPTION
     WHEN l_not_a_group_therefore_no_poe
      THEN
        NULL;
  END;

  RETURN retval;
--
   nm_debug.proc_end(g_package_name,'get_node_class');
--
END get_node_class;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_g_ne_id_to_restrict_on (pi_ne_id IN nm_elements.ne_id%TYPE) IS

BEGIN
 g_ne_id_to_restrict_on := pi_ne_id;
END set_g_ne_id_to_restrict_on;
--
-----------------------------------------------------------------------------
--
FUNCTION get_g_ne_id_to_restrict_on RETURN nm_elements.ne_id%TYPE IS

BEGIN
  RETURN(g_ne_id_to_restrict_on);
END get_g_ne_id_to_restrict_on;
--
-----------------------------------------------------------------------------
--
END nm3net_o;
/
