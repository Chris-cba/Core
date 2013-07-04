CREATE OR REPLACE PACKAGE BODY Nm_Cncts IS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm_cncts.pkb-arc   2.3   Jul 04 2013 15:07:20   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_cncts.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 15:07:20  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:22  $
--       PVCS Version     : $Revision:   2.3  $
--       Based on            1.5
--
--   Author : Rob Coupe
--
--   NM3 Connectivity package
--
-------------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------


FUNCTION Set_Ia_Ptr ( p_ia IN int_array ) RETURN ptr_array;
FUNCTION Get_Cnct_No ( p_ne_id IN nm_elements.ne_id%TYPE ) RETURN nm_cnct_no_array;
FUNCTION Get_Cnct_No ( p_list IN int_array ) RETURN nm_cnct_no_array;
FUNCTION Get_Cnct_Ne ( p_ne_id IN nm_elements.ne_id%TYPE ) RETURN nm_cnct_ne_array;
FUNCTION Get_Cnct_Ne ( p_list IN int_array ) RETURN nm_cnct_ne_array;
FUNCTION Create_Tmp_Spatial_Extent ( p_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE
                                    ,p_geom IN mdsys.sdo_geometry
				                    ,p_mask IN VARCHAR2 DEFAULT 'ANYINTERACT' ) RETURN NUMBER;
FUNCTION Get_Batch_Of_Base_Nn( p_theme IN NUMBER, p_geom IN mdsys.sdo_geometry, p_ne_array IN  nm_cnct_ne_array_type ) RETURN ptr_array;
FUNCTION Init_Nm_Cnct_Ne_Array RETURN nm_cnct_ne_array;
FUNCTION Init_Nm_Cnct_No_Array RETURN nm_cnct_no_array;

--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_cnct RETURN nm_cnct IS
BEGIN
  RETURN g_cnct;
END;

--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_no_array RETURN nm_cnct_no_array_type IS
BEGIN
  RETURN g_cnct.nc_no_array.ncno_array;
END;

--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_ne_array RETURN nm_cnct_ne_array_type IS
BEGIN
  RETURN g_cnct.nc_ne_array.ncne_array;
END;

--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_no_ptr_array RETURN ptr_array_type IS
BEGIN
  RETURN g_cnct.nc_no_ptr.pa;
END;

--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
PROCEDURE init_start_and_end_nodes IS
BEGIN
  g_start_node := NULL;
  g_end_node   := NULL;
END;

--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
PROCEDURE Set_No_Ptrs( p_no IN OUT NOCOPY nm_cnct_no_array, p_no_ptr IN ptr_array ) IS
l_ia int_array := int_array(int_array_type(NULL));
FUNCTION get_id( p_no IN INTEGER ) RETURN INTEGER IS
retval INTEGER;
BEGIN
  FOR i IN 1..p_no_ptr.pa.LAST LOOP
    IF p_no_ptr.pa(i).ptr_value = p_no THEN
	  retval := p_no_ptr.pa(i).ptr_id;
	  EXIT;
	END IF;
  END LOOP;
  RETURN retval;
END;

BEGIN
  FOR i IN 1.. p_no.ncno_array.LAST LOOP
    p_no.ncno_array(i).row_id := get_id( p_no.ncno_array(i).no_id );
  END LOOP;
END;

--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
PROCEDURE Set_Ne_Ptrs( p_ne IN OUT NOCOPY nm_cnct_ne_array)  IS
BEGIN
--  nm_debug.debug('set_ne_ptrs');

  FOR i IN 1..p_ne.ncne_array.LAST LOOP
    p_ne.ncne_array(i).row_id := i;

--  nm_debug.debug(to_char(i)||', ne_array rowid = '||to_char(l_ia.ia(i)));
  END LOOP;
END;


--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--

PROCEDURE set_start_and_end_nodes IS
  l_term nm_cnct_no_array := g_cnct.Get_Start_And_End_Nodes;
  type_1 VARCHAR2(1) := l_term.ncno_array(1).no_type;
  type_2 VARCHAR2(1) := l_term.ncno_array(2).no_type;
BEGIN
  g_start_node := NULL;
  g_end_node   := NULL;

  IF type_1 = type_2 THEN
    g_start_node := l_term.ncno_array(2).no_id;
	g_end_node   := l_term.ncno_array(1).no_id;
  ELSIF type_1 = 'S' THEN
    g_start_node := l_term.ncno_array(1).no_id;
	g_end_node   := l_term.ncno_array(2).no_id;
  ELSIF type_1 = 'E' THEN
    g_start_node := l_term.ncno_array(2).no_id;
	g_end_node   := l_term.ncno_array(1).no_id;
  END IF;
END;

--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--

FUNCTION get_start_node RETURN INTEGER IS
BEGIN
  RETURN g_start_node;
END;

FUNCTION get_end_node RETURN INTEGER IS
BEGIN
  RETURN g_end_node;
END;

--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--

PROCEDURE instantiate_link_array( p_dir_flag IN VARCHAR2 DEFAULT 'FALSE') IS
nc  INTEGER;
i1  INTEGER;
i2  INTEGER;
dir BOOLEAN := (p_dir_flag = 'TRUE');

l_link nm_cnct_link;

BEGIN

--  nm_debug.debug_on;

  nc := g_cnct.nc_no_ptr.pa.LAST;

  g_cnct.nc_link.ncla_link.EXTEND( nc*nc - 1 );

--
--set cost
--

  FOR i IN 1..nc LOOP

    g_cnct.nc_link.ncla_link(nc*(i-1)+i) := nm_cnct_link( i, i, 0, NULL );

  END LOOP;

--nm_debug.debug('setting node ids from 1 to '||to_char(g_cnct.nc_ne_array.ncne_array.last));

  FOR i IN 1..g_cnct.nc_ne_array.ncne_array.LAST LOOP

--  nm_debug.debug('Start Node = '||to_char(g_cnct.nc_ne_array.ncne_array(i).no_st));

    i1 := g_cnct.nc_no_array.no_in_array( g_cnct.nc_ne_array.ncne_array(i).no_st );

--  nm_debug.debug('Start Ptr = '||to_char(i1));

--  nm_debug.debug('End Node = '||to_char(g_cnct.nc_ne_array.ncne_array(i).no_end));

	i2 := g_cnct.nc_no_array.no_in_array( g_cnct.nc_ne_array.ncne_array(i).no_end );

--  nm_debug.debug('End Ptr = '||to_char(i2));

	IF i1 != i2 THEN

	  IF i1 < i2 THEN

--      nm_debug.debug('Setting array element '||to_char(nc*(i1-1)+i2));


        l_link := nm_cnct_link( i1, i2, g_cnct.nc_ne_array.ncne_array(i).ne_length,
		                                               int_array(int_array_type( g_cnct.nc_ne_array.ncne_array(i).row_id )) );

--        l_link.cost := least( l_link.cost, g_cnct.nc_link.ncla_link(nc*(i1-1)+i2).cost);

		g_cnct.nc_link.ncla_link(nc*(i1-1)+i2) := l_link;


  	  ELSE

		l_link := nm_cnct_link( i2, i1, g_cnct.nc_ne_array.ncne_array(i).ne_length,
		                                               int_array(int_array_type( g_cnct.nc_ne_array.ncne_array(i).row_id )) );

--        l_link.cost := least( l_link.cost,g_cnct.nc_link.ncla_link(nc*(i2-1)+i1).cost);

        g_cnct.nc_link.ncla_link(nc*(i2-1)+i1) := l_link;

	  END IF;

	END IF;

  END LOOP;

  g_cnct_link_flag := TRUE;

END;

--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
PROCEDURE complete_link_table (p_dir_flag IN VARCHAR2 DEFAULT 'FALSE') IS
nc         INTEGER;
l_linkd_s  nm_cnct_link;
l_linkd_i  nm_cnct_link;
l_linki_s  nm_cnct_link;
l_link     nm_cnct_link;

i1         INTEGER;
i2         INTEGER;
i3         INTEGER;
i4         INTEGER;
l_cost     NUMBER;
l_path     int_array;
it_count   INTEGER;

there_are_changes  BOOLEAN := TRUE;

BEGIN

  nc := g_cnct.nc_no_ptr.pa.LAST;

  IF nc > g_node_limit THEN

    RAISE_APPLICATION_ERROR( -20001, 'Node count exceeded');

  END IF;

  it_count := 0;

  WHILE there_are_changes LOOP

	there_are_changes := FALSE;

    FOR d IN 1..nc LOOP

      FOR s IN d+1..nc LOOP

        l_linkd_s := g_cnct.nc_link.ncla_link(nc*(d-1)+s);	--save the link

		l_cost := l_linkd_s.COST;

		IF l_cost IS NULL THEN
		  l_cost := Nm3type.c_big_number;
		END IF;

		FOR i IN 1..nc LOOP                                 --find all connections to this link and update as neccessary

          it_count := it_count + 1;

		  IF i != d AND i != s THEN

--		    nm_debug.debug('Destination = '||to_char(d)||' Source = '||to_char(s)||' Trying '||to_char(i));

		    i1 := LEAST(i,d);
			i2 := GREATEST(i,d);

		    i3 := LEAST(s,i);
			i4 := GREATEST(i,s);

  		    l_linkd_i := g_cnct.nc_link.ncla_link(nc*(i1-1)+i2);

  		    l_linki_s := g_cnct.nc_link.ncla_link(nc*(i3-1)+i4);

			IF l_linkd_i.COST IS NOT NULL AND l_linki_s.COST IS NOT NULL THEN

--			  nm_debug.debug('costs are not null - di = '||to_char(l_linkd_i.cost)||' is = '||to_char(l_linki_s.cost));

			  IF l_cost > l_linkd_i.COST +  l_linki_s.COST THEN

--              l_link := nm_cnct_link( d, s, l_linkd_i.COST + l_linki_s.COST, Ia_Append(l_linkd_i.path, l_linki_s.path));
                l_link := nm_cnct_link( d, s, l_linkd_i.COST + l_linki_s.COST, l_linkd_i.path.append( l_linki_s.path));

--              nm_debug.debug('generate new link ('||to_char(d)||','||to_char(s)||') - current cost is '||to_char( l_cost )||' new cost = '||to_char(l_linkd_i.cost +  l_linki_s.cost));

				there_are_changes := TRUE;

 			    g_cnct.nc_link.ncla_link(nc*(d-1)+s) := l_link;

              END IF;

--          else

--			  nm_debug.debug('costs are null - di = '||to_char(l_linkd_i.cost)||' is = '||to_char(l_linki_s.cost));

  		    END IF;

		  END IF;

	    END LOOP;
      END LOOP;
    END LOOP;
  END LOOP;

  g_cnct_complete := TRUE;

--nm_debug.debug('Count = '||to_char(it_count));

END;


--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_path_from_complete_link( p_no_st IN INTEGER, p_no_end INTEGER, p_dir_flag VARCHAR2 DEFAULT 'FALSE' ) RETURN nm_placement_array IS

nc         INTEGER;

l_link     nm_cnct_link;
l_st       INTEGER;
l_end      INTEGER;
l1         INTEGER;
l2         INTEGER;
l_ne       INTEGER;
l_len      NUMBER;
l_start    INTEGER := 0;

retval     nm_placement_array;


BEGIN

--  nm_debug.debug_on;

  IF NOT g_cnct_link_flag THEN
    instantiate_link_array( p_dir_flag );
	complete_link_table;
  END IF;

  nc := g_cnct.nc_no_ptr.pa.LAST;

  l_st  :=  g_cnct.nc_no_array.no_in_array( p_no_st );

  l_end :=  g_cnct.nc_no_array.no_in_array( p_no_end );

  l1 := LEAST(l_st, l_end);
  l2 := GREATEST(l_st, l_end);

--  nm_debug.debug('Node pointers are from '||to_char(l1)||' to '||to_char(l2));

  l_link := g_cnct.nc_link.ncla_link(nc*(l1-1) + l2 );

  IF l_link.COST IS NULL THEN
    RAISE_APPLICATION_ERROR(-20001,'No connection between the two points');
  END IF;

  FOR i IN 1..l_link.path.ia.LAST LOOP

    l_ne  := g_cnct.nc_ne_array.ncne_array(l_link.path.ia(i)).ne_id;
	l_len := g_cnct.nc_ne_array.ncne_array(l_link.path.ia(i)).ne_length;

    IF i = 1 THEN

	  retval := nm_placement_array(nm_placement_array_type( nm_placement( l_ne, 0, l_len, 0 )));

    ELSE

	  retval := retval.add_element( l_ne, 0, l_len );

	END IF;

  END LOOP;

  RETURN retval;

END;

--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
PROCEDURE init_link_from_node( p_no_id IN INTEGER ) IS

CURSOR c1( c_no_id IN INTEGER, c_no IN INTEGER ) IS
  SELECT nm_cnct_link(c_no_id, p.ptr_id, e.ne_length, int_array(int_array_type(e.row_id)))
  FROM TABLE ( g_cnct.nc_no_array.ncno_array ) n,
       TABLE ( g_cnct.nc_ne_array.ncne_array ) e,
	   TABLE ( g_cnct.nc_no_ptr.pa ) p
  WHERE n.no_id = c_no
  AND   n.ne_id = e.ne_id
  AND   DECODE( n.no_type, 'E', no_st, 'S', no_end ) = p.ptr_value
  AND   DECODE( n.no_type, 'S', no_st, 'E', no_end ) = n.no_id
  ORDER BY p.ptr_id;

l_link_array nm_cnct_link_array := nm_cnct_link_array( nm_cnct_link_array_type( nm_cnct_link(NULL, NULL, NULL, int_array(int_array_type(NULL)))));
l_link       nm_cnct_link;

l_no_id INTEGER;

nc      INTEGER;

BEGIN

--  Nm_Debug.debug_on;

  nc := g_cnct.nc_no_ptr.pa.LAST;

  l_no_id := g_cnct.nc_no_array.no_in_array( p_no_id );

--  Nm_Debug.DEBUG('delaing with node '||TO_CHAR( p_no_id )||' found at no: '||TO_CHAR(l_no_id));

  g_cnct.nc_link.ncla_link.EXTEND ( nc - 1);

  FOR i IN 1..g_cnct.nc_no_ptr.pa.LAST LOOP
    g_cnct.nc_link.ncla_link(i) := nm_cnct_link(l_no_id, NULL, NULL, int_array(int_array_type(NULL)));
--    Nm_Debug.DEBUG('Init row '||TO_CHAR(i));
  END LOOP;

  g_cnct.nc_link.ncla_link(l_no_id) := nm_cnct_link(l_no_id, l_no_id, 0, int_array(int_array_type(NULL)));

--  Nm_Debug.DEBUG('fetch into temp link using node '||TO_CHAR(l_no_id ));

  OPEN c1 (l_no_id, p_no_id);
  FETCH c1 BULK COLLECT INTO l_link_array.ncla_link;
  CLOSE c1;

--  Nm_Debug.DEBUG( 'Temp link array - count = '||TO_CHAR(l_link_array.ncla_link.LAST));

  FOR i IN 1..l_link_array.ncla_link.LAST LOOP

    IF l_link_array.ncla_link(i).j != l_no_id THEN

	  IF g_cnct.nc_link.ncla_link( l_link_array.ncla_link(i).j ).COST IS NULL THEN
  	    g_cnct.nc_link.ncla_link( l_link_array.ncla_link(i).j ) := l_link_array.ncla_link(i);
      ELSIF g_cnct.nc_link.ncla_link( l_link_array.ncla_link(i).j ).COST >  l_link_array.ncla_link(i).COST THEN
        g_cnct.nc_link.ncla_link( l_link_array.ncla_link(i).j )  := l_link_array.ncla_link(i);
	  END IF;

	END IF;

  END LOOP;


/*
  nm_debug.debug_on;

  for i in 1..g_cnct.nc_link.ncla_link.last loop

    l_link := g_cnct.nc_link.ncla_link(i);

    nm_debug.debug( 'I='||to_char(l_link.I)||' J='||to_char(l_link.J)||' Cost='||to_char(l_link.cost)||' path='||to_char( l_link.path.ia(1)));
  end loop;

*/


END;


--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_path( p_no_st IN INTEGER, p_no_end IN INTEGER ) RETURN nm_placement_array IS

l_link   nm_cnct_link;

l_st     INTEGER;
l_end    INTEGER;

w INTEGER;

nc       INTEGER := g_cnct.nc_no_ptr.pa.LAST;

l_no_considered ptr_array := g_cnct.nc_no_ptr;

there_are_changes  BOOLEAN := TRUE;

l_cost   NUMBER;
l_ne_row INTEGER;
l_ne     INTEGER;
l_len    NUMBER;

retval nm_placement_array;

FUNCTION get_min_cost_no RETURN INTEGER IS
l_min NUMBER := Nm3type.c_big_number;
l_id  INTEGER;
BEGIN
--nm_debug.debug('Min cost');
  FOR i IN 1..g_cnct.nc_no_ptr.pa.LAST LOOP
--  nm_debug.debug('Check value = '||to_char(l_no_considered.pa(i).ptr_value)||' min = '||to_char(l_min));

    IF l_no_considered.pa(i).ptr_value > 0 THEN
      IF g_cnct.nc_link.ncla_link(i).COST < l_min THEN
--	    nm_debug.debug('New min = '||to_char( i ));
	    l_min := g_cnct.nc_link.ncla_link(i).COST;
	    l_id  := i;
	  END IF;
    END IF;
  END LOOP;
  RETURN l_id;
END;

--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_link( p1 IN INTEGER, p2 IN INTEGER ) RETURN NUMBER IS
retval NUMBER := NULL;
l1 INTEGER;
l2 INTEGER;
BEGIN

  l1 := g_cnct.nc_no_ptr.pa(p1).ptr_value;
  l2 := g_cnct.nc_no_ptr.pa(p2).ptr_value;

  FOR i IN 1..g_cnct.nc_ne_array.ncne_array.LAST LOOP
    IF ( g_cnct.nc_ne_array.ncne_array(i).no_st = l1 AND
	     g_cnct.nc_ne_array.ncne_array(i).no_end = l2 )   OR
       ( g_cnct.nc_ne_array.ncne_array(i).no_st = l2 AND
	     g_cnct.nc_ne_array.ncne_array(i).no_end = l1 )  THEN

 	  retval :=  g_cnct.nc_ne_array.ncne_array(i).row_id;
	  EXIT;

	END IF;
  END LOOP;
  RETURN retval;
END;


BEGIN

  l_st  :=  g_cnct.nc_no_array.no_in_array( p_no_st );

  l_end :=  g_cnct.nc_no_array.no_in_array( p_no_end );

--nm_debug.debug('Init the considered array '||to_char(l_no_considered.pa.last));

  l_no_considered.pa(l_st).ptr_value := -1;
/*
  for i in 1..l_no_considered.pa.last loop
    if g_cnct.nc_link.ncla_link(i).cost is not null then
	  l_no_considered.pa(i).ptr_value := -1;
	end if;
  end loop;
*/

--nm_debug.debug('Top loop');

  w := get_min_cost_no;

  WHILE w IS NOT NULL LOOP

    l_no_considered.pa(w).ptr_value := -1;

--	nm_debug.debug('Min cost id = '||to_char(w));

    FOR n IN 1..g_cnct.nc_no_ptr.pa.LAST LOOP

      IF n != l_st AND n != w THEN

	    l_ne_row := get_link(w, n);

--      nm_debug.debug('Testing link between '||to_char(w)||' and '||to_char(n)||' = '||to_char(l_ne_row));

	    IF l_ne_row IS NOT NULL THEN

--        nm_debug.debug('Passed the not null test');

		  l_cost := g_cnct.nc_ne_array.ncne_array(l_ne_row).ne_length;

  	      IF g_cnct.nc_link.ncla_link(n).COST IS NULL OR
               g_cnct.nc_link.ncla_link(n).COST > l_cost + g_cnct.nc_link.ncla_link(w).COST THEN

            l_link := nm_cnct_link( l_st, n, l_cost + g_cnct.nc_link.ncla_link(w).COST,
			               g_cnct.nc_link.ncla_link(w).path.append( int_array(int_array_type(g_cnct.nc_ne_array.ncne_array(l_ne_row).row_id))));
--	                Ia_Append(  g_cnct.nc_link.ncla_link(w).path, int_array(int_array_type(g_cnct.nc_ne_array.ncne_array(l_ne_row).row_id))));

            g_cnct.nc_link.ncla_link(n) := l_link;

--		    there_are_changes := TRUE;

		  END IF;

/*
        else

          nm_debug.debug('No link');
*/

		END IF;
	  END IF;

	END LOOP;

    w := get_min_cost_no;

-- 	nm_debug.debug('Next for consideration is '||to_char(w));

  END LOOP;

--  nm_debug.debug('End of loop - end = '||to_char(l_end));

  IF g_cnct.nc_link.ncla_link(l_end).COST IS NULL THEN
    RAISE_APPLICATION_ERROR(-20001, 'No path');
  ELSE
    l_link := g_cnct.nc_link.ncla_link(l_end);
  END IF;

  FOR i IN 1..l_link.path.ia.LAST LOOP

    l_ne  := g_cnct.nc_ne_array.ncne_array(l_link.path.ia(i)).ne_id;
	l_len := g_cnct.nc_ne_array.ncne_array(l_link.path.ia(i)).ne_length;

    IF i = 1 THEN

	  retval := nm_placement_array(nm_placement_array_type( nm_placement( l_ne, 0, l_len, 0 )));

    ELSE

	  retval := retval.add_element( l_ne, 0, l_len );

	END IF;

  END LOOP;

  RETURN retval;
END;


--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
PROCEDURE make_cnct_from_tmp_extent ( p_job_id IN NM_NW_TEMP_EXTENTS.NTE_JOB_ID%TYPE )  IS

l_no_ptr ptr_array;
l_ia     int_array;

CURSOR c_no ( c_job_id IN NM_NW_TEMP_EXTENTS.NTE_JOB_ID%TYPE ) IS
  SELECT /*+INDEX (n, NNU_NE_FK_IND)*/nm_cnct_no(NULL, n.nnu_no_node_id, n.nnu_ne_id, n.nnu_node_type)
  FROM nm_node_usages n, NM_NW_TEMP_EXTENTS m
  WHERE m.nte_job_id = c_job_id
  AND   n.nnu_ne_id = m.nte_ne_id_of;

CURSOR c_ne ( c_job_id IN NM_NW_TEMP_EXTENTS.NTE_JOB_ID%TYPE ) IS
  SELECT /*+INDEX (NM_ELEMENTS_ALL,NE_PK)*/nm_cnct_ne(NULL, e.ne_id, e.ne_no_start, e.ne_no_end, ne_length)
  FROM nm_elements e, NM_NW_TEMP_EXTENTS m
  WHERE m.nte_job_id = c_job_id
  AND   e.ne_id = m.nte_ne_id_of;

l_la     nm_cnct_link_array := nm_cnct_link_array( nm_cnct_link_array_type(nm_cnct_link( NULL, NULL, NULL, int_array( int_array_type(NULL)))));

l_no nm_cnct_no_array := nm_cnct_no_array( nm_cnct_no_array_type( nm_cnct_no( NULL, NULL, NULL, NULL)));
l_ne nm_cnct_ne_array := nm_cnct_ne_array( nm_cnct_ne_array_type( nm_cnct_ne( NULL, NULL, NULL, NULL, NULL)));

BEGIN

--nm_debug.debug_on;

  OPEN c_no( p_job_id );
  FETCH c_no BULK COLLECT INTO l_no.ncno_array;
  CLOSE c_no;

--nm_debug.debug('Node count = '||to_char(l_no.ncno_array.last));
  OPEN c_ne( p_job_id);
  FETCH c_ne BULK COLLECT INTO l_ne.ncne_array;
  CLOSE c_ne;

--nm_debug.debug('Element count = '||to_char(l_ne.ncne_array.last));

  l_ia := l_no.distinct_nodes;

  l_no_ptr := Set_Ia_Ptr( l_ia );

  Set_No_Ptrs( l_no, l_no_ptr );

  Set_Ne_Ptrs(l_ne);

  reset_globals;

  g_cnct := nm_cnct( l_no_ptr, l_no, l_ne, l_la, NULL, NULL, NULL);

  g_cnct_instantiated := TRUE;

END;

--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--

PROCEDURE make_cnct_from_extent ( p_nse_id IN NM_SAVED_EXTENTS.NSE_ID%TYPE ) IS
l_no_ptr ptr_array;
l_ia     int_array;


CURSOR c_no ( c_nse_id IN NM_SAVED_EXTENTS.NSE_ID%TYPE) IS
  SELECT /*+INDEX (n, NNU_NE_FK_IND)*/nm_cnct_no(NULL, n.nnu_no_node_id, n.nnu_ne_id, n.nnu_node_type)
  FROM nm_node_usages n, NM_SAVED_EXTENT_MEMBER_DATUMS m
  WHERE m.nsd_nse_id = c_nse_id
  AND   n.nnu_ne_id = m.nsd_ne_id;

CURSOR c_ne ( c_nse_id IN NM_SAVED_EXTENTS.NSE_ID%TYPE) IS
  SELECT /*+INDEX (NM_ELEMENTS_ALL,NE_PK)*/nm_cnct_ne(NULL, e.ne_id, e.ne_no_start, e.ne_no_end, ne_length)
  FROM nm_elements e, NM_SAVED_EXTENT_MEMBER_DATUMS m
  WHERE m.nsd_nse_id = c_nse_id
  AND   e.ne_id = m.nsd_ne_id;

l_la     nm_cnct_link_array := nm_cnct_link_array( nm_cnct_link_array_type(nm_cnct_link( NULL, NULL, NULL, int_array( int_array_type(NULL)))));

l_no nm_cnct_no_array := nm_cnct_no_array( nm_cnct_no_array_type( nm_cnct_no( NULL, NULL, NULL, NULL)));
l_ne nm_cnct_ne_array := nm_cnct_ne_array( nm_cnct_ne_array_type( nm_cnct_ne( NULL, NULL, NULL, NULL, NULL)));

BEGIN

--nm_debug.debug_on;

  OPEN c_no( p_nse_id );
  FETCH c_no BULK COLLECT INTO l_no.ncno_array;
  CLOSE c_no;

--nm_debug.debug('Node count = '||to_char(l_no.ncno_array.last));
  OPEN c_ne( p_nse_id);
  FETCH c_ne BULK COLLECT INTO l_ne.ncne_array;
  CLOSE c_ne;

--nm_debug.debug('Element count = '||to_char(l_ne.ncne_array.last));


  l_ia := l_no.distinct_nodes;

  l_no_ptr := Set_Ia_Ptr( l_ia );

  Set_No_Ptrs( l_no, l_no_ptr );

  Set_Ne_Ptrs ( l_ne );

  reset_globals;

  g_cnct := nm_cnct( l_no_ptr, l_no, l_ne, l_la, NULL, NULL, NULL);

  g_cnct_instantiated := TRUE;

END;

PROCEDURE make_nm_cnct_from_ne ( p_ne_id IN nm_elements.ne_id%TYPE,
                                 p_obj_type IN nm_members.nm_obj_type%TYPE DEFAULT NULL ) IS

retval nm_cnct;

l_cnct_ne nm_cnct_ne_array := Get_Cnct_Ne( p_ne_id );
l_cnct_no nm_cnct_no_array := Get_Cnct_No( p_ne_id );

l_la     nm_cnct_link_array := nm_cnct_link_array( nm_cnct_link_array_type(nm_cnct_link( NULL, NULL, NULL, int_array( int_array_type(NULL)))));

l_no_ptr ptr_array;

l_ia     int_array;

FUNCTION Is_Empty RETURN BOOLEAN IS
BEGIN
  IF l_cnct_ne.ncne_array(1).ne_id IS NULL THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END;

BEGIN

  IF Is_Empty THEN
    RAISE_APPLICATION_ERROR( -20001, 'Empty dataset, cannot instantiate the object');
  ELSE

--  Nm_Debug.debug_on;

    l_ia := l_cnct_no.distinct_nodes;

--    Nm_Debug.DEBUG('distinct nodes retrieved');

--	for i in 1..l_ia.ia.last loop

--	  nm_debug.debug('distinct node '||to_char(i)||' = '||to_char(l_ia.ia(i)) );

--	end loop;

    l_no_ptr := Set_Ia_Ptr( l_ia );


    Set_No_Ptrs( l_cnct_no, l_no_ptr );

--    Nm_Debug.DEBUG('Node ptrs');

    Set_Ne_Ptrs( l_cnct_ne );

--    Nm_Debug.DEBUG('Node ptrs');

    reset_globals;

    g_cnct := nm_cnct( l_no_ptr, l_cnct_no, l_cnct_ne, l_la, NVL( p_obj_type, Nm3net.get_gty_type( p_ne_id )), NULL, NULL);

  END IF;

  g_cnct_instantiated := TRUE;

--  Nm_Debug.DEBUG('end of make_nm_cnct_from_ne');
END;
--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
PROCEDURE make_nm_cnct_from_ne_list ( p_list IN int_array, p_obj_type IN nm_members.nm_obj_type%TYPE  ) IS

retval nm_cnct;

l_cnct_ne nm_cnct_ne_array := Get_Cnct_Ne( p_list );
l_cnct_no nm_cnct_no_array := Get_Cnct_No( p_list );

l_la     nm_cnct_link_array := nm_cnct_link_array( nm_cnct_link_array_type(nm_cnct_link( NULL, NULL, NULL, int_array( int_array_type(NULL)))));

l_no_ptr ptr_array;

l_ia     int_array;

FUNCTION Is_Empty RETURN BOOLEAN IS
BEGIN
  IF l_cnct_ne.ncne_array(1).ne_id IS NULL THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END;

BEGIN

  IF Is_Empty THEN
    RAISE_APPLICATION_ERROR( -20001, 'Empty dataset, cannot instantiate the object');
  ELSE

--  nm_debug.debug_on;

    l_ia := l_cnct_no.distinct_nodes;

--	for i in 1..l_ia.ia.last loop

--	  nm_debug.debug('distinct node '||to_char(i)||' = '||to_char(l_ia.ia(i)) );

--	end loop;

    l_no_ptr := Set_Ia_Ptr( l_ia );

    Set_No_Ptrs( l_cnct_no, l_no_ptr );

    Set_Ne_Ptrs( l_cnct_ne );

    reset_globals;

    g_cnct := nm_cnct( l_no_ptr, l_cnct_no, l_cnct_ne, l_la, p_obj_type, NULL, NULL);

  END IF;

  g_cnct_instantiated := TRUE;

END;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

FUNCTION get_pl_by_xy ( p_layer IN NUMBER,
                               p_x1 IN NUMBER,
                               p_y1 IN NUMBER,
                               p_x2 IN NUMBER,
                               p_y2 IN NUMBER,
							   p_compl_flag VARCHAR2 DEFAULT 'N' ) RETURN nm_placement_array IS

retval        nm_placement_array;
l_start       nm_lref;
l_end         nm_lref;
l_no_st       INTEGER;
l_no_end      INTEGER;
l_end_bits    nm_cnct_ne_array;
l_st_in_path  BOOLEAN;
l_end_in_path BOOLEAN;
lq VARCHAR2(1) := CHR(39);

FUNCTION join_ne_array ( p_ptr IN ptr_array, p_ncne IN nm_cnct_ne_array_type ) RETURN ptr_array IS
CURSOR c1 ( c_ptr IN ptr_array, c_ncne IN nm_cnct_ne_array_type ) IS
  SELECT ptr( c.ptr_id, c.ptr_value )
  FROM TABLE ( c_ptr.pa ) c, TABLE ( c_ncne ) b
  WHERE c.ptr_value = b.ne_id
  AND ROWNUM = 1
  ORDER BY c.ptr_id;

retval ptr_array := Nm3array.init_ptr_array;
BEGIN
  OPEN c1( p_ptr, p_ncne );
  FETCH c1 BULK COLLECT INTO retval.pa;
  CLOSE c1;
  RETURN retval;
END;

FUNCTION get_nearest ( p_nth_id IN INTEGER, p_x IN NUMBER, p_y IN NUMBER ) RETURN nm_lref IS
l_ne ptr_array:= Nm3array.INIT_PTR_ARRAY;
l_ge mdsys.sdo_geometry;
BEGIN

--  l_ne := Nm3sdo.Get_Batch_Of_Base_Nn( p_nth_id, Nm3sdo.get_2d_pt (p_x, p_y));

  l_ne := Get_Batch_Of_Base_Nn( p_nth_id, Nm3sdo.get_2d_pt (p_x, p_y), g_cnct.nc_ne_array.ncne_array);

  IF l_ne.pa.LAST IS NULL OR l_ne.pa.LAST = 0 THEN
--    Nm_Debug.debug_on;
--    Nm_Debug.DEBUG('Probs ne.pa.last is '||TO_CHAR( l_ne.pa.LAST ));

    RAISE_APPLICATION_ERROR(-20001, 'No street elements close enough to the xy co-ordinates');

  END IF;

--  l_ne := join_ne_array( l_ne, g_cnct.nc_ne_array.ncne_array );

  l_ge := Nm3sdo.get_projection( p_nth_id, l_ne.pa(1).ptr_value, p_x, p_y );

  RETURN nm_lref( l_ne.pa(1).ptr_value, Nm3unit.get_formatted_value( l_ge.sdo_ordinates(3), Nm3net.get_nt_units_from_ne(l_ne.pa(1).ptr_value)));

--RETURN Nm3sdo.get_nearest_nw_to_xy( p_x, p_y, nm_theme_array( nm_theme_array_type( nm_theme_entry( p_nth_id ))));
END;

FUNCTION Get_Nearest_Node( p_lref IN nm_lref ) RETURN INTEGER IS
retval INTEGER;
BEGIN
  FOR i IN 1..g_cnct.nc_ne_array.ncne_array.LAST LOOP
    IF g_cnct.nc_ne_array.ncne_array(i).ne_id = p_lref.lr_ne_id THEN

      retval := g_cnct.nc_ne_array.ncne_array(i).no_st;

	  IF g_cnct.nc_ne_array.ncne_array(i).ne_length - p_lref.lr_offset <  p_lref.lr_offset THEN

	    retval := g_cnct.nc_ne_array.ncne_array(i).no_end;

	  END IF;
	  EXIT;
	END IF;
  END LOOP;
  RETURN retval;
END;


/*
PROCEDURE subtract_part( p_pla IN OUT NOCOPY nm_placement_array, p_pl nm_placement ) IS
l_last INTEGER := p_pla.npa_placement_array.LAST;
jpt  INTEGER;
BEGIN
  FOR i IN 1..l_last LOOP
    jpt := l_last - i + 1;
	IF p_pla.npa_placement_array(jpt).pl_ne_id = p_pl.pl_ne_id THEN
	  IF p_pla.npa_placement_array(jpt).pl_start = p_pl.pl_start AND
	     p_pla.npa_placement_array(jpt).pl_end   > p_pl.pl_end THEN
        p_pla.npa_placement_array(jpt).pl_end := p_pl.pl_end;
      ELSIF p_pla.npa_placement_array(jpt).pl_end = p_pl.pl_end AND
	     p_pla.npa_placement_array(jpt).pl_start < p_pl.pl_start THEN
        p_pla.npa_placement_array(jpt).pl_end := p_pl.pl_start;
	  END IF;
	  EXIT;
	END IF;
  END LOOP;
END;
*/

FUNCTION subtract_part( p_pla IN  nm_placement_array, p_pl nm_placement ) RETURN nm_placement_array IS
l_last INTEGER := p_pla.npa_placement_array.LAST;
retval nm_placement_array := p_pla;
jpt  INTEGER;
BEGIN

--Nm_Debug.DEBUG( 'subtract '||TO_CHAR( p_pl.pl_ne_id )||','||TO_CHAR(p_pl.pl_start)||' to '||TO_CHAR(p_pl.pl_end));

  FOR i IN 1..l_last LOOP
    jpt := l_last - i + 1;
	IF retval.npa_placement_array(jpt).pl_ne_id = p_pl.pl_ne_id THEN

      IF retval.npa_placement_array(jpt).pl_start >= p_pl.pl_start AND
         retval.npa_placement_array(jpt).pl_end   <= p_pl.pl_end THEN

--      Nm_Debug.DEBUG('remove row');
        NULL;


      ELSIF retval.npa_placement_array(jpt).pl_start < p_pl.pl_start AND
            retval.npa_placement_array(jpt).pl_end   > p_pl.pl_end THEN

--      Nm_Debug.DEBUG('need to split the row - this should not happen');
        NULL;

      ELSIF retval.npa_placement_array(jpt).pl_start = p_pl.pl_start AND
            retval.npa_placement_array(jpt).pl_end   > p_pl.pl_end THEN

--      Nm_Debug.DEBUG('adjust the start - ');

        retval.npa_placement_array(jpt) := nm_placement( p_pl.pl_ne_id, p_pl.pl_end, retval.npa_placement_array(jpt).pl_end, 0);

      ELSIF retval.npa_placement_array(jpt).pl_start < p_pl.pl_start AND
            retval.npa_placement_array(jpt).pl_end   = p_pl.pl_end THEN

--      Nm_Debug.DEBUG('adjust the end');

        retval.npa_placement_array(jpt) := nm_placement( p_pl.pl_ne_id,retval.npa_placement_array(jpt).pl_start, p_pl.pl_start, 0);

      END IF;

	  EXIT;

	END IF;
  END LOOP;
  RETURN retval;
END;

BEGIN

  IF is_cnct_instantiated = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Network not instantiated, cannot compute the connectivity');
  END IF;

--Timer.set_timer;

--  Nm_Debug.debug_on;

--  Nm_Debug.DEBUG('get_pl_by_xy start - first get the nearest element to xy');
/*
  l_start := nm3sdo.get_projection_to_nearest(p_layer, p_x1, p_y1);
  l_end   := nm3sdo.get_projection_to_nearest(p_layer, p_x2, p_y2);
*/

  l_start := get_nearest(p_layer, p_x1, p_y1);
  l_end   := get_nearest(p_layer, p_x2, p_y2);

--Timer.set_time('Start and end found');

--  Nm_Debug.DEBUG( 'st = '||TO_CHAR( l_start.lr_ne_id)||' - '||TO_CHAR(l_start.lr_offset));
--  Nm_Debug.DEBUG( 'end= '||TO_CHAR( l_end.lr_ne_id)||' - '||TO_CHAR(l_end.lr_offset));

  IF l_start.lr_ne_id = l_end.lr_ne_id THEN

--	Nm_Debug.DEBUG('same element so no need for walking');

    IF l_start.lr_offset < l_end.lr_offset THEN

      RETURN nm_placement_array( nm_placement_array_type( nm_placement( l_start.lr_ne_id, l_start.lr_offset, l_end.lr_offset, 0 )));

    ELSIF l_start.lr_offset > l_end.lr_offset THEN

      RETURN nm_placement_array( nm_placement_array_type( nm_placement( l_start.lr_ne_id, l_end.lr_offset, l_start.lr_offset, 0 )));

    ELSE
       RAISE_APPLICATION_ERROR (-20001, 'points are the same - no distance between them');

    END IF;

  ELSE

--	Nm_Debug.DEBUG('different element - need for walking');

	IF g_cnct IS NULL THEN

--	  Nm_Debug.DEBUG('not instantiated, instantiate from buffer around line joining points');

--    Timer.set_time('make cnct from line');

	  make_cnct_from_line( p_layer, mdsys.sdo_geometry( 2002, NULL, NULL, mdsys.sdo_elem_info_array(1,2,1),mdsys.sdo_ordinate_array( p_x1, p_y1, p_x2, p_y2 )), 0.2 );

    END IF;

--  Timer.set_time( 'cnct is made, get nearest nodes');

    l_no_st := Get_Nearest_Node( l_start );

	l_no_end := Get_Nearest_Node( l_end );

--    Nm_Debug.DEBUG('st no = '||TO_CHAR(l_no_st));
--    Nm_Debug.DEBUG('end no= '||TO_CHAR(l_no_end));

    IF p_compl_flag = 'Y' THEN

	  IF NOT g_cnct_complete THEN

--      Timer.set_time('Instantiate and complete link table');

		instantiate_link_array;
		complete_link_table;

--      Timer.set_time('Instantiate and complete link table - finished');

	  END IF;

--	  Nm_Debug.DEBUG('using a completed link');

--    Timer.set_time( 'get path from complete link');

  	  retval := get_path_from_complete_link( l_no_st, l_no_end );

--    Timer.set_time( 'get path from complete link - finished');

	ELSE

	  IF g_cnct_complete THEN

  --      Nm_Debug.DEBUG('Get path between nodes '||TO_CHAR(l_no_st)||' and '||TO_CHAR(l_no_end));

--      Timer.set_time( 'get path from complete link');

	    retval := get_path_from_complete_link( l_no_st, l_no_end );

--      Timer.set_time( 'get path from complete link - finished');

--        Nm_Debug.DEBUG('end of get_path');

	  ELSE

        IF l_no_st != l_no_end THEN

--	      Nm_Debug.DEBUG('using a single node - from '||TO_CHAR(l_no_st)||' to '||TO_CHAR(l_no_end));

--        Timer.set_time( 'init link table from single node');

	      init_link_from_node( l_no_st );

--        Timer.set_time('init link form node has finished - now get the path');

          retval := get_path( l_no_st, l_no_end );

--   	  Timer.set_time('path from node has finished');

        ELSE

/*

          DECLARE
            l_ne nm_cnct_ne_array;
          BEGIN
            l_ne := g_cnct.nc_ne_array.get_elements_in_array( int_array( int_array_type( l_start.lr_ne_id, l_end.lr_ne_id )));

            retval := nm_placement_array( nm_placement_array_type( nm_placement( NULL, NULL, NULL, NULL )));

            FOR i IN 1.. l_ne.ncne_array.LAST LOOP
              retval := retval.add_element( nm_placement( l_ne.ncne_array(i).ne_id, 0, l_ne.ncne_array(i).ne_length, 0 ), FALSE );
            END LOOP;
          END;

*/
          retval := nm_placement_array( nm_placement_array_type( nm_placement( NULL, NULL, NULL, NULL )));

        END IF;

 	  END IF;
	END IF;

--    Nm_Debug.debug_off;

--  Timer.set_time('tidy up the partial bits');

    l_st_in_path  := ( retval.find_element(l_start.lr_ne_id) > 0 );

    l_end_in_path := ( retval.find_element(l_end.lr_ne_id) > 0 );

/*
    Nm_Debug.DEBUG('Find end element in path '||TO_CHAR(l_end.lr_ne_id ));

    IF l_end_in_path THEN
      Nm_Debug.DEBUG('Found');
    ELSE
      Nm_Debug.DEBUG('not Found');
    END IF;
*/
--
--  Now assess the fragments from the initial start/end point to the start/end node.
--

--     Nm_Debug.DEBUG( 'get end bits');

     l_end_bits := g_cnct.nc_ne_array.get_elements_in_array( int_array(int_array_type(l_start.lr_ne_id, l_end.lr_ne_id)));

/*
     FOR i IN 1..l_end_bits.ncne_array.LAST LOOP

       Nm_Debug.DEBUG( TO_CHAR( l_end_bits.ncne_array(i).row_id)||', '||TO_CHAR( l_end_bits.ncne_array(i).ne_id )||', '||TO_CHAR( l_end_bits.ncne_array(i).no_st )||', '||TO_CHAR( l_end_bits.ncne_array(i).no_end ));

     END LOOP;
*/

--
     IF NOT l_st_in_path THEN
--
--     the starting element is not already in the path - we may need to add some
--
       IF l_no_st = l_end_bits.ncne_array(1).no_st THEN

--       The start node is the start of the path so the fragment from the start node to the starting measure needs to be added.

--       Nm_Debug.DEBUG( 'start/start - offset (add) = '||TO_CHAR(l_start.lr_offset));

         IF l_start.lr_offset > 0 THEN
           retval := retval.add_element( l_start.lr_ne_id, 0, l_start.lr_offset, 0, FALSE );
         END IF;

 	   ELSIF l_no_st = l_end_bits.ncne_array(1).no_end THEN

--       The start node is the end of the fist element so the fragment from the starting measure to the end node needs to be added.

--       Nm_Debug.DEBUG( 'start/end - offset (add) = '||TO_CHAR(l_start.lr_offset)||' length = '||TO_CHAR(l_end_bits.ncne_array(1).ne_length));

         IF l_start.lr_offset < l_end_bits.ncne_array(1).ne_length THEN
           retval := retval.add_element( l_start.lr_ne_id, l_start.lr_offset,  l_end_bits.ncne_array(1).ne_length, 0, FALSE );
         END IF;

	   END IF;

     ELSE

--     the starting element is already included in the path - we may need to subtract some

       IF l_no_st = l_end_bits.ncne_array(1).no_st THEN

--       The start node is the start of the path so the fragment from the start node to the starting measure needs to be subtracted

--       Nm_Debug.DEBUG( 'start/start - offset (minus) = '||TO_CHAR(l_start.lr_offset));

         IF l_start.lr_offset > 0 THEN
	       retval := Subtract_Part(retval, nm_placement( l_start.lr_ne_id, 0, l_start.lr_offset, 0));
--	       subtract_part(retval, nm_placement( l_start.lr_ne_id, 0, l_start.lr_offset, 0));
         END IF;

 	   ELSIF l_no_st = l_end_bits.ncne_array(1).no_end THEN

--       The start node is the end of the fist element so the fragment from the starting measure to the end node needs to be added.

--       Nm_Debug.DEBUG( 'start/end - offset (minus) = '||TO_CHAR(l_start.lr_offset)||' length = '||TO_CHAR(l_end_bits.ncne_array(1).ne_length));

         IF l_start.lr_offset < l_end_bits.ncne_array(1).ne_length THEN
		   retval := Subtract_Part(retval, nm_placement( l_start.lr_ne_id, l_start.lr_offset, l_end_bits.ncne_array(1).ne_length, 0));
--		   subtract_part(retval, nm_placement( l_start.lr_ne_id, l_start.lr_offset, l_end_bits.ncne_array(1).ne_length, 0));
         END IF;

	   END IF;

     END IF;

     IF NOT l_end_in_path THEN
--
--     the end element is not already in the path - we may need to add some
--
       IF l_no_end = l_end_bits.ncne_array(2).no_st THEN

--       end node is the end of path so add the fragment from the start node to the end measure.

--       Nm_Debug.DEBUG( 'end/start - offset (add) = '||TO_CHAR(l_end.lr_offset));

         IF l_end.lr_offset > 0 THEN
           retval := retval.add_element( l_end.lr_ne_id, 0, l_end.lr_offset, 0, FALSE );
         END IF;

 	   ELSIF l_no_end = l_end_bits.ncne_array(2).no_end THEN

--       The end node is the end of the last element so the fragment from the starting measure to the end node needs to be added.

--       Nm_Debug.DEBUG( 'end/end - offset (add) = '||TO_CHAR(l_end.lr_offset)||' length = '||TO_CHAR(l_end_bits.ncne_array(2).ne_length));

         IF l_end.lr_offset < l_end_bits.ncne_array(2).ne_length THEN
           retval := retval.add_element( l_end.lr_ne_id, l_end.lr_offset,  l_end_bits.ncne_array(2).ne_length, 0, FALSE );
         END IF;

	   END IF;

     ELSE

--     the last element is already included in the path - we may need to subtract some

       IF l_no_end = l_end_bits.ncne_array(2).no_st THEN

--       The end node is the start of the last element in the path so subtract

--       Nm_Debug.DEBUG( 'end/start - offset (minus) = '||TO_CHAR(l_end.lr_offset));

         IF l_end.lr_offset > 0 THEN
	       retval := Subtract_Part(retval, nm_placement( l_end.lr_ne_id, 0, l_end.lr_offset, 0));
--	       subtract_part(retval, nm_placement( l_end.lr_ne_id, 0, l_end.lr_offset, 0));
         END IF;

 	   ELSIF l_no_end = l_end_bits.ncne_array(2).no_end THEN

--       The end node is the end of the last element so the fragment from the end measure to the end node needs to be subtracted

--       Nm_Debug.DEBUG( 'end/end - offset (minus) = '||TO_CHAR(l_end.lr_offset)||' length = '||TO_CHAR(l_end_bits.ncne_array(2).ne_length));

         IF l_end.lr_offset < l_end_bits.ncne_array(2).ne_length THEN
		   retval := Subtract_Part(retval, nm_placement( l_end.lr_ne_id, l_end.lr_offset, l_end_bits.ncne_array(2).ne_length, 0));
--		   subtract_part(retval, nm_placement( l_end.lr_ne_id, l_end.lr_offset, l_end_bits.ncne_array(2).ne_length, 0));
         END IF;

	   END IF;

     END IF;

  END IF;

--  Nm_Debug.DEBUG('end of get_pl_by_xy');
--Timer.set_time('Finished');

  RETURN retval;

END;

--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--


PROCEDURE make_cnct_from_line (l_theme_id IN INTEGER, p_geom IN mdsys.sdo_geometry, p_scale IN NUMBER DEFAULT 0.05 ) IS

l_geom   mdsys.sdo_geometry;
l_buffer NUMBER;

BEGIN

  l_buffer := sdo_geom.sdo_length( p_geom, .005) * p_scale;

  l_geom :=  sdo_geom.sdo_buffer( p_geom, l_buffer, .005 );

  Nm_Cncts.make_cnct_from_tmp_extent( Create_Tmp_Spatial_Extent( l_theme_id, l_geom));

  g_cnct_instantiated := TRUE;

END;

--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
PROCEDURE reset_globals IS
BEGIN
  g_cnct_instantiated := FALSE;
  g_cnct_link_flag    := FALSE;
  g_cnct_complete     := FALSE;

  g_start_node := NULL;
  g_end_node   := NULL;

END;

--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--

FUNCTION Set_Ia_Ptr ( p_ia IN int_array ) RETURN ptr_array IS
retval ptr_array := ptr_array( ptr_array_type( ptr( NULL, NULL )));
BEGIN
  SELECT ptr(ROWNUM, COLUMN_VALUE)
  BULK COLLECT INTO retval.pa
  FROM TABLE ( p_ia.ia ) p;

--  nm_debug.debug('Set_ia_ptr');

/*
  for i in 1..p_ia.ia.last loop
    nm_debug.debug( to_char(i)||', '||to_char(retval.pa(i).ptr_id)||', '||to_char(retval.pa(i).ptr_value));
  end loop;
*/
  RETURN retval;
END;

--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
FUNCTION Get_Cnct_No ( p_ne_id IN nm_elements.ne_id%TYPE ) RETURN nm_cnct_no_array IS
retval nm_cnct_no_array := Init_Nm_Cnct_No_Array;

CURSOR c_no ( c_ne_id IN nm_elements.ne_id%TYPE) IS
  SELECT /*+INDEX (n, NNU_NE_FK_IND)*/nm_cnct_no(NULL, n.nnu_no_node_id, n.nnu_ne_id, n.nnu_node_type)
  FROM nm_node_usages n, nm_members m
  WHERE m.nm_ne_id_in = c_ne_id
  AND   n.nnu_ne_id = m.nm_ne_id_of;

BEGIN

  OPEN c_no( p_ne_id );
  FETCH c_no BULK COLLECT INTO retval.ncno_array;
  CLOSE c_no;

  RETURN retval;

END;

--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--

FUNCTION Get_Cnct_No ( p_list IN int_array  ) RETURN nm_cnct_no_array IS
retval nm_cnct_no_array := Init_Nm_Cnct_No_Array;
/*

CURSOR c_no ( c_ia IN int_array) IS
  SELECT /*+INDEX (n, NNU_NE_FK_IND)*/ /*nm_cnct_no(NULL, n.nnu_no_node_id, n.nnu_ne_id, n.nnu_node_type)
  FROM nm_node_usages n, TABLE ( c_ia.ia ) e
  WHERE n.nnu_ne_id = e.COLUMN_VALUE;
*/

curstr varchar2(2000);

BEGIN

  curstr := 'select /*+cardinality( e '||to_char( p_list.ia.last)||') INDEX (n.NNU_NE_FK_IND)*/ '||
            'nm_cnct_no(NULL, n.nnu_no_node_id, n.nnu_ne_id, n.nnu_node_type) '||
            'FROM nm_node_usages n, TABLE ( :ia ) e '||
            'WHERE n.nnu_ne_id = e.COLUMN_VALUE ';

  execute immediate curstr bulk collect into retval.ncno_array using p_list.ia;

/*
  OPEN c_no( p_list );
  FETCH c_no BULK COLLECT INTO retval.ncno_array;
  CLOSE c_no;
*/

  RETURN retval;

END;

--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--

FUNCTION Get_Cnct_Ne ( p_ne_id IN nm_elements.ne_id%TYPE ) RETURN nm_cnct_ne_array IS
retval nm_cnct_ne_array := Init_Nm_Cnct_Ne_Array;

CURSOR c_ne ( c_ne_id IN nm_elements.ne_id%TYPE) IS
  SELECT nm_cnct_ne(NULL, e.ne_id, e.ne_no_start, e.ne_no_end, ne_length)
  FROM nm_elements e, nm_members m
  WHERE m.nm_ne_id_in = c_ne_id
  AND   m.nm_ne_id_of = e.ne_id;

BEGIN

  OPEN c_ne( p_ne_id );
  FETCH c_ne BULK COLLECT INTO retval.ncne_array;
  CLOSE c_ne;

--  Nm_Debug.debug_on;
--  Nm_Debug.DEBUG('last = '||TO_CHAR(retval.ncne_array.LAST));
  IF retval.ncne_array.LAST IS NULL  THEN
    RAISE_APPLICATION_ERROR( -20001, 'Empty dataset, cannot instantiate the object');
  END IF;


  RETURN retval;

END;

--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
FUNCTION Get_Cnct_Ne ( p_list IN int_array ) RETURN nm_cnct_ne_array IS
retval nm_cnct_ne_array := Init_Nm_Cnct_Ne_Array;

/*
CURSOR c_ne ( c_ia IN int_array) IS
  SELECT nm_cnct_ne(NULL, e.ne_id, e.ne_no_start, e.ne_no_end, ne_length)
  FROM nm_elements e, TABLE ( c_ia.ia ) a
  WHERE e.ne_id = a.COLUMN_VALUE;
*/

curstr varchar2(2000);

BEGIN

  curstr := ' SELECT /*+cardinality( a '||to_char(p_list.ia.last)||') */ '|| 'nm_cnct_ne(NULL, e.ne_id, e.ne_no_start, e.ne_no_end, ne_length) '||
            ' FROM nm_elements e, TABLE ( :ia ) a '||
            ' WHERE e.ne_id = a.COLUMN_VALUE ';


/*
  OPEN c_ne( p_list );
  FETCH c_ne BULK COLLECT INTO retval.ncne_array;
  CLOSE c_ne;
*/

--  Nm_Debug.debug_on;

--  nm_debug.debug(curstr);

--  Nm_Debug.DEBUG('last = '||TO_CHAR(retval.ncne_array.LAST));

  execute immediate curstr bulk collect into retval.ncne_array using p_list.ia;

  IF retval.ncne_array.LAST IS NULL  THEN
    RAISE_APPLICATION_ERROR( -20001, 'Empty dataset, cannot instantiate the object');
  END IF;


  RETURN retval;

END;

--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--

FUNCTION Create_Tmp_Spatial_Extent ( p_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE
                                                       ,p_geom IN mdsys.sdo_geometry
													   ,p_mask IN VARCHAR2 DEFAULT 'ANYINTERACT' ) RETURN NUMBER IS


  lf     VARCHAR2(1) := CHR(13);

  cur_string Nm3type.max_varchar2;

  l_nte      INTEGER := Nm3seq.next_nte_id_seq;

  nthrow     NM_THEMES_ALL%ROWTYPE;

BEGIN

   nthrow := Nm3get.get_nth( p_theme_id );

   cur_string := ' INSERT INTO NM_NW_TEMP_EXTENTS ( '||lf||
       ' NTE_JOB_ID , NTE_NE_ID_OF  , NTE_BEGIN_MP,  '||lf||
       ' NTE_END_MP , NTE_CARDINALITY, NTE_SEQ_NO, '||lf||
       ' NTE_ROUTE_NE_ID) '||lf||
       ' select :nte_job, s.ne_id, 0, nm3net.get_ne_length( s.ne_id ),'||lf||
       ' 1, rownum, null '||lf||
     ' from '||nthrow.nth_feature_table||'  s '||lf||
     ' where  sdo_relate(  s.'||nthrow.nth_feature_shape_column||' , :l_geom, '||''''||'mask='||p_mask||''''||') = '||''''||'TRUE'||'''';

  EXECUTE IMMEDIATE cur_string USING l_nte, p_geom;

--  Nm_Debug.DEBUG('Temp extent = '||TO_CHAR(l_nte));

  RETURN l_nte;

END;
--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
FUNCTION  is_cnct_instantiated RETURN INTEGER IS
--function returns zero for not instantiated
--                 one  for instantiated
--                 two  for instantiated and having a completed link array
BEGIN
  IF g_cnct_instantiated THEN
    IF g_cnct_complete THEN
      RETURN 2;
    ELSE
      RETURN 1;
    END IF;
  ELSE
    RETURN 0;
  END IF;
END;

--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
FUNCTION Get_Batch_Of_Base_Nn( p_theme IN NUMBER, p_geom IN mdsys.sdo_geometry, p_ne_array IN  nm_cnct_ne_array_type ) RETURN ptr_array IS

nthrow NM_THEMES_ALL%ROWTYPE;
nthbas NM_THEMES_ALL%ROWTYPE;
nthmet user_sdo_geom_metadata%ROWTYPE;

retval ptr_array := Nm3array.init_ptr_array;

cur_string VARCHAR2(2000);

FUNCTION join_ncne ( p_pa IN ptr_array_type, p_ncne IN nm_cnct_ne_array_type ) RETURN ptr_array_type IS
CURSOR c1 (  c_pa IN ptr_array_type, c_ncne IN nm_cnct_ne_array_type ) IS
  SELECT ptr( a.ptr_id, a.ptr_value )
  FROM TABLE( c_pa ) a,
       TABLE( c_ncne ) b
  WHERE a.ptr_value = b.ne_id
  ORDER BY a.ptr_id;
retval ptr_array_type := ptr_array_type( ptr( NULL, NULL ));
BEGIN
  OPEN c1 ( p_pa, p_ncne);
  FETCH c1 BULK COLLECT INTO retval;
  CLOSE c1;

  RETURN retval;
END;

BEGIN

  nthrow := Nm3get.get_nth( p_theme );
  nthbas := nthrow;

  IF nthbas.nth_base_table_theme IS NOT NULL THEN

    nthrow := Nm3get.get_nth( nthrow.nth_base_table_theme );

  END IF;

  nthmet := Nm3sdo.get_theme_metadata( p_theme);

  cur_string := 'select ptr(rownum, ne_id) from ( select ft.'||nthrow.nth_feature_pk_column||' ne_id, mdsys.SDO_NN_DISTANCE(1) dist'||
                ' from '||nthrow.nth_feature_table||' ft '||
                'where sdo_nn( '||nthrow.nth_feature_shape_column||', :p_geom ,'||''''||
                'SDO_BATCH_SIZE='||TO_CHAR(10)||''''||', 1) = '||''''||'TRUE'||''''||
                ' and rownum <= 50 ) '||
                ' where dist <= '||NVL(nthrow.nth_tolerance, 10);

  EXECUTE IMMEDIATE cur_string BULK COLLECT INTO retval.pa USING p_geom; -- p_ne_array, p_geom;

  IF retval.pa.LAST IS NOT NULL THEN
    retval.pa := join_ncne( retval.pa, p_ne_array );
  END IF;

  RETURN retval;
END;


--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--


FUNCTION Init_Nm_Cnct_Ne_Array RETURN nm_cnct_ne_array IS
BEGIN
  RETURN nm_cnct_ne_array( nm_cnct_ne_array_type ( nm_cnct_ne( NULL, NULL, NULL, NULL, NULL )));
END;

--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--


FUNCTION Init_Nm_Cnct_No_Array RETURN nm_cnct_no_array IS
BEGIN
  RETURN nm_cnct_no_array( nm_cnct_no_array_type ( nm_cnct_no( NULL, NULL, NULL, NULL)));
END;
--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--


END;
/
