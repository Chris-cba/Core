CREATE OR REPLACE PACKAGE BODY nm3route_check AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3route_check.pkb-arc   2.2   Jul 04 2013 16:21:12   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3route_check.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:21:12  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:18  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 1.4
-------------------------------------------------------------------------

--
--   Author : R Coupe
--
--   template package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
     g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.2  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3route_check';
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
FUNCTION get_seq_sub_class( p_gty IN nm_elements.ne_gty_group_type%TYPE,
                            p_seq IN nm_type_subclass.nsc_seq_no%TYPE ) 
				  RETURN nm_type_subclass.nsc_sub_class%TYPE IS
--
CURSOR c1( c_gty nm_elements.ne_gty_group_type%TYPE,
           c_seq nm_type_subclass.nsc_seq_no%TYPE) IS
  SELECT nsc_sub_class
  FROM nm_type_subclass, nm_nt_groupings_all
  WHERE nng_group_type = c_gty
  AND nng_nt_type = nsc_nw_type
  AND nsc_seq_no  = c_seq;
  
retval   nm_type_subclass.nsc_sub_class%TYPE;

BEGIN
  OPEN c1( p_gty, p_seq );
  FETCH c1 INTO retval;
  CLOSE c1;
  RETURN retval;
END;
  
-----------------------------------------------------------------------------
--
PROCEDURE route_check(pi_ne_id               IN     nm_elements.ne_id%TYPE
                     ,po_route_status        OUT pls_integer
                     ,po_offending_datums    OUT nm3type.tab_varchar30
                     ) IS

  e_route_ill_formed EXCEPTION;

  -- All start of R in the middle of a route with no end of S and no end of R

  l_gty nm_elements.ne_gty_group_type%TYPE := nm3net.get_ne_gty( pi_ne_id );
  
  
  CURSOR c1 ( c_ne_id nm_elements.ne_id%TYPE) IS
    SELECT s.ne_unique
    FROM nm_elements s, nm_members sm, nm_node_usages a
    WHERE s.ne_id = a.nnu_ne_id
    AND s.ne_id = sm.nm_ne_id_of
    AND sm.nm_ne_id_in = c_ne_id
    AND s.ne_sub_class = g_r
    AND a.nnu_node_type = 'S'   --start of right
    AND NOT EXISTS ( SELECT 1 FROM nm_elements e, nm_members em, nm_node_usages b
                     WHERE e.ne_id = b.nnu_ne_id
                     AND e.ne_id = em.nm_ne_id_of
                     AND em.nm_ne_id_in = sm.nm_ne_id_in
                     AND e.ne_sub_class IN ( g_r, g_s)
                     AND b.nnu_node_type = 'E' )
    AND EXISTS ( SELECT 1 FROM nm_elements e, nm_members em, nm_node_usages b
                   WHERE e.ne_id = b.nnu_ne_id
                   AND e.ne_id = em.nm_ne_id_of
                   AND em.nm_ne_id_in = sm.nm_ne_id_in
                   AND b.nnu_node_type = 'E' );


  -- All start of L in the middle of a route with no end of S and no end of L

  CURSOR c2 ( c_ne_id nm_elements.ne_id%TYPE) IS
    SELECT s.ne_unique
    FROM nm_elements s, nm_members sm, nm_node_usages a
    WHERE s.ne_id = a.nnu_ne_id
    AND s.ne_id = sm.nm_ne_id_of
    AND sm.nm_ne_id_in = c_ne_id
    AND s.ne_sub_class = g_l
    AND a.nnu_node_type = 'S'   --start of right
    AND NOT EXISTS ( SELECT 1 FROM nm_elements e, nm_members em, nm_node_usages b
                     WHERE e.ne_id = b.nnu_ne_id
                     AND e.ne_id = em.nm_ne_id_of
                     AND em.nm_ne_id_in = sm.nm_ne_id_in
                     AND e.ne_sub_class IN ( g_l,g_s)
                     AND b.nnu_node_type = 'E' )
    AND EXISTS ( SELECT 1 FROM nm_elements e, nm_members em, nm_node_usages b
                   WHERE e.ne_id = b.nnu_ne_id
                   AND e.ne_id = em.nm_ne_id_of
                   AND em.nm_ne_id_in = sm.nm_ne_id_in
                   AND b.nnu_node_type = 'E' );


  -- all ends of the same sub-class or a single with either L or R

  CURSOR c3 ( c_ne_id nm_elements.ne_id%TYPE) IS
    SELECT a1.ne_unique, b1.ne_unique, DECODE( a.nnu_node_type, 'S', 'Start', 'E','End','')
    FROM nm_elements a1, nm_members sm1, nm_members sm2,
         nm_node_usages a, nm_node_usages b, nm_elements b1
    WHERE a1.ne_id = a.nnu_ne_id
    AND a1.ne_id = sm1.nm_ne_id_of
    AND sm1.nm_ne_id_in = c_ne_id
    AND sm2.nm_ne_id_in = c_ne_id
    AND a.nnu_no_node_id = b.nnu_no_node_id  --same node
    AND b1.ne_id = b.nnu_ne_id
    AND b1.ne_id = sm2.nm_ne_id_of
    AND a1.ne_id != b1.ne_id
    AND a.nnu_node_type = b.nnu_node_type -- same node type
    AND (((a1.ne_sub_class = g_s
           OR
           b1.ne_sub_class = g_s)   -- If end of single, then no other end should be there
          OR
          (a1.ne_sub_class = b1.ne_sub_class)) -- end should not be the same sub-class
         OR
         a1.ne_type = 'D'); --also get distance breaks as they don't have a sub class

  CURSOR get_start_and_end (c_ne_id    nm_elements.ne_id%TYPE
                           ,c_type     nm_node_usages.nnu_node_type%TYPE
                   ) IS
    SELECT u1.nnu_ne_id
    FROM nm_node_usages u1, nm_members a
    WHERE u1.nnu_node_type = c_type
    AND   u1.nnu_ne_id = a.nm_ne_id_of
    AND   a.nm_ne_id_in = c_ne_id
    AND   NOT EXISTS ( SELECT 1 FROM nm_members b, nm_node_usages u2
       WHERE u2.nnu_node_type != u1.nnu_node_type
       AND   u2.nnu_ne_id = b.nm_ne_id_of
       AND   b.nm_ne_id_in = c_ne_id
       AND   u1.nnu_ne_id != u2.nnu_ne_id
       AND   u1.nnu_no_node_id = u2.nnu_no_node_id );

  l_unique1 nm_elements.ne_unique%TYPE;
  l_unique2 nm_elements.ne_unique%TYPE;

  l_s_or_e varchar2(10);

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'route_check');

  IF nm3net.is_sub_class_used( l_gty ) THEN					 

    g_s := get_seq_sub_class( l_gty, 1 );
	g_l := get_seq_sub_class( l_gty, 2 );
	g_r := get_seq_sub_class( l_gty, 3 );

    po_route_status := 0;
  
    OPEN c1( pi_ne_id );
    FETCH c1 INTO l_unique1;
    IF c1%FOUND
    THEN
      CLOSE c1;
  
      --Start of Right exists with no compatible end
      po_route_status := 5;
      po_offending_datums(1) := l_unique1;
  
      RAISE e_route_ill_formed;
  
    ELSE
      CLOSE c1;
      OPEN c2( pi_ne_id );
      FETCH c2 INTO l_unique1;
      IF c2%FOUND
      THEN
        CLOSE c2;
  
        --Start of Left exists with no compatible end
        po_route_status := 10;
        po_offending_datums(1) := l_unique1;
  
        RAISE e_route_ill_formed;
  
      ELSE
        CLOSE c2;
        OPEN c3( pi_ne_id );
        FETCH c3 INTO l_unique1, l_unique2, l_s_or_e;
        IF c3%FOUND
        THEN
          IF l_s_or_e = 'S'
          THEN
            --Start of '||l_unique1||' and '||l_unique2||' are incompatible
            po_route_status := 15;
          ELSE
            --End of '||l_unique1||' and '||l_unique2||' are incompatible
            po_route_status := 20;
          END IF;
  
          po_offending_datums(1) := l_unique1;
          po_offending_datums(2) := l_unique2;
  
          RAISE e_route_ill_formed;
        END IF;
        CLOSE c3;
      END IF;
    END IF; 
  END IF;

  --check start of route
  terminus_check(pi_ne_id => pi_ne_id
                ,pi_type  => 'S');

  				

  --check end of route
  terminus_check(pi_ne_id => pi_ne_id
                ,pi_type  => 'E');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'route_check');

EXCEPTION
  WHEN e_route_ill_formed
  THEN
    RETURN;

END route_check;
--
-----------------------------------------------------------------------------
--
PROCEDURE terminus_check(pi_ne_id IN nm_elements.ne_id%TYPE
                        ,pi_type IN nm_node_usages.nnu_node_type%TYPE
                        ) IS

  CURSOR check_st_end(c_ne_id nm_elements.ne_id%TYPE
                     ,c_dir   integer 
                     ) IS				 
    SELECT u1.nnu_ne_id nnu_ne_id, u1.nnu_no_node_id nnu_no_node_id,  
	       ne.ne_unique ne_unique, ne.ne_sub_class ne_sub_class, nm_cardinality
    FROM nm_node_usages u1, nm_members a, nm_elements ne
    WHERE nm3net.route_direction(u1.nnu_node_type,a.nm_cardinality) = c_dir
    AND   u1.nnu_ne_id = a.nm_ne_id_of
    AND   a.nm_ne_id_in = c_ne_id
    AND   u1.nnu_ne_id = ne.ne_id
    AND   NOT EXISTS (SELECT 1 FROM nm_members b, nm_node_usages u2
                      WHERE nm3net.route_direction(u2.nnu_node_type,b.nm_cardinality) !=
                            nm3net.route_direction(u1.nnu_node_type,a.nm_cardinality)
                      AND   u2.nnu_ne_id = b.nm_ne_id_of
                      AND   b.nm_ne_id_in = a.nm_ne_id_in
                      AND   u1.nnu_ne_id != u2.nnu_ne_id
                      AND   u1.nnu_no_node_id = u2.nnu_no_node_id);
					  
					  

  l_node_id  nm_nodes.no_node_id%TYPE;
  l_node_sav nm_nodes.no_node_id%TYPE;
  l_scl_sav  nm_elements.ne_sub_class%TYPE;
  
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'terminus_check');

  FOR irec IN check_st_end ( pi_ne_id, nm3net.get_type_sign(pi_type))
  LOOP
    IF check_st_end%rowcount= 1
    THEN
      l_node_sav := irec.nnu_no_node_id;
      l_scl_sav  := irec.ne_sub_class;
	  
	  IF nm3net.get_type_sign(pi_type) = 1 THEN
	    g_ne_st  := irec.nnu_ne_id;
	  ELSE
	    g_ne_end := irec.nnu_ne_id;
	  END IF;
    ELSE
      --check nodes
      IF l_node_sav != irec.nnu_no_node_id
      THEN
        IF pi_type = 'S'
        THEN
          hig.raise_ner(nm3type.c_net, 161, -20355 );
        ELSE
          hig.raise_ner(nm3type.c_net, 162, -20355 );
        END IF;
      END IF;

      --check sub classes
	  
	  IF nm3net.is_sub_class_used( nm3net.get_ne_gty( pi_ne_id )) THEN	
	  
        IF irec.ne_sub_class = g_s --'S' must be on its own
          OR l_scl_sav = g_s
          OR irec.ne_sub_class = l_scl_sav --duplicate sub classes at terminus are not allowed
        THEN
          IF pi_type = 'S'
          THEN
            hig.raise_ner(nm3type.c_net, 163, -20357 );
          ELSE
            hig.raise_ner(nm3type.c_net, 164, -20358 );
          END IF;
        END IF;
      END IF;
    END IF;	  
  END LOOP;

  IF NOT nm3net.is_sub_class_used( nm3net.get_ne_gty( pi_ne_id )) THEN	
	  
--   no sub-class is used. it could be partial - check that the internal
--   connectivity is OK

     partial_check( pi_ne_id );
		

  END IF;
  
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'terminus_check');

END terminus_check;
--

PROCEDURE partial_check( pi_ne_id IN nm_elements.ne_id%TYPE ) IS

  CURSOR check_partial ( c_ne_id nm_elements.ne_id%TYPE,
                         c_se_id nm_elements.ne_id%TYPE,
                         c_dir   integer ) IS
      SELECT 1
      FROM nm_members, nm_node_usages, nm_elements
      WHERE nnu_ne_id = nm_ne_id_of
      AND nm_ne_id_in = c_ne_id
      AND nm3net.route_direction( nnu_node_type, nm_cardinality ) = c_dir
      AND nm_ne_id_of = ne_id
      AND (( nnu_node_type = 'S' AND nm_begin_mp > 0) OR
           ( nnu_node_type = 'E' AND NVL(nm_end_mp, ne_length) < ne_length))
	  AND ne_id != c_se_id;
	  
  dummy integer;
	  

BEGIN   
   OPEN check_partial( pi_ne_id, g_ne_st, 1 );
   FETCH check_partial INTO dummy;
   IF check_partial%FOUND THEN
     CLOSE check_partial;
     hig.raise_ner(nm3type.c_net, 263);
   ELSE
     CLOSE check_partial;
   END IF;
   
   OPEN check_partial( pi_ne_id, g_ne_end, -1 );
   FETCH check_partial INTO dummy;
   IF check_partial%FOUND THEN
     CLOSE check_partial;   
     hig.raise_ner(nm3type.c_net, 263);
   ELSE
     CLOSE check_partial;
   END IF;
END;		            
----------------------------------------------------------------------------
--
END nm3route_check;
/
