CREATE OR REPLACE PACKAGE BODY Nm3pla AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3pla.pkb-arc   2.12   Jun 21 2012 14:08:52   Rob.Coupe  $
--       Module Name      : $Workfile:   nm3pla.pkb  $
--       Date into PVCS   : $Date:   Jun 21 2012 14:08:52  $
--       Date fetched Out : $Modtime:   Jun 21 2012 12:32:44  $
--       Version          : $Revision:   2.12  $
--       Based on SCCS version : 1.61
------------------------------------------------------------------------
--
--   Author : Rob Coupe
--
--    Placements package
--
-------------------------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2000
-------------------------------------------------------------------------------------------
-- Global variables - tree definitions etc.
   --g_body_sccsid     CONSTANT  VARCHAR2(2000) := '"@(#)nm3pla.pkb	1.61 11/29/06"';
   g_body_sccsid     CONSTANT varchar2(2000) := '$Revision:   2.12  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT VARCHAR2(30) := 'nm3pla';
--
TYPE tree_rec IS RECORD (r_ne_id       nm_elements.ne_id%TYPE
                        ,r_st_node     nm_elements.ne_no_start%TYPE
                        ,r_end_node    nm_elements.ne_no_end%TYPE
                        ,r_length      nm_elements.ne_length%TYPE
                        ,r_offset_st   nm_members.nm_slk%TYPE
                        );

TYPE tree_tab IS TABLE OF tree_rec INDEX BY BINARY_INTEGER;

route_tree    tree_tab;
g_tree_index  BINARY_INTEGER := 0;

--base units of elements in group
g_e_units nm_types.nt_length_unit%TYPE;

CURSOR cst( c_st_node NUMBER, c_ne_id NUMBER ) IS
   SELECT ne_id, ne_length, ne_no_end end_node FROM
   nm_elements, nm_members
   WHERE ne_no_start = c_st_node
   AND ne_id = nm_ne_id_of
   AND nm_ne_id_in = c_ne_id;

/*
cursor cpl ( c_node number, c_ne_id number ) is
  select next element details from node and route id
*/
g_pl       nm_placement_array;
--
g_route_unit      NUMBER;
g_element_unit    NUMBER;
--
g_pla_exception   EXCEPTION;
g_pla_exc_code    NUMBER := -20001;
g_pla_exc_msg     VARCHAR2(2000) := 'Unspecified exception within NM3PLA';
--
  TYPE rec_conn_chunk IS RECORD
      (iof       nm_members.nm_ne_id_of%TYPE
      ,ibegin    nm_members.nm_begin_mp%TYPE
      ,iend      nm_members.nm_end_mp%TYPE
      ,rin       nm_members.nm_ne_id_in%TYPE
      ,rseq      nm_members.nm_seq_no%TYPE
      ,ne_length nm_elements.ne_length%TYPE
      );
  TYPE tab_rec_conn_chunk IS TABLE OF rec_conn_chunk INDEX BY BINARY_INTEGER;
--
  g_conn_chunk tab_rec_conn_chunk;
--
--------------------------------------------------------------------------------------------------------------------
--
FUNCTION local_connected_chunks RETURN nm_placement_array;
--
-------------------------------------------------------------------------------------------
--

FUNCTION partial_chunk_connectivity(rvrs IN integer,
                             p1 IN NUMBER,

                             p2 IN NUMBER,
                             d1 in integer,
                             d2 in integer,
                             s1 IN NUMBER,
                             e1 IN NUMBER,
                             s2 IN NUMBER,
                             e2 IN NUMBER  ) RETURN integer;
--
-------------------------------------------------------------------------------------------
--
FUNCTION get_version RETURN VARCHAR2 IS
BEGIN
  RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-------------------------------------------------------------------------------------------
--
PROCEDURE set_tree_id( p_tree_id IN BINARY_INTEGER ) IS
BEGIN
  Nm_Debug.proc_start(g_package_name,'set_tree_id');
  g_tree_index := p_tree_id;
  Nm_Debug.proc_end(g_package_name,'set_tree_id');
END;
--
-------------------------------------------------------------------------------------------
--
FUNCTION  get_tree_index RETURN NUMBER IS
  l_ix NUMBER;
BEGIN
  Nm_Debug.proc_start(g_package_name,'get_tree_index');
  l_ix := TO_NUMBER(g_tree_index);
  Nm_Debug.proc_end(g_package_name,'get_tree_index');
  RETURN l_ix;
END;
--
-------------------------------------------------------------------------------------------
--
PROCEDURE set_route_offsets (p_ne_id     IN NUMBER
                            ,p_offset_st IN NUMBER
                            ) IS

CURSOR get_start ( c_ne_id NUMBER ) IS
  SELECT s.ne_id ne_id, s.ne_no_start st_node, s.ne_no_end end_node, s.ne_length ne_length, m1.nm_cardinality CARDINALITY
  FROM nm_elements s, nm_members m1
  WHERE  s.ne_id = m1.nm_ne_id_of
  AND    m1.nm_ne_id_in = c_ne_id
  AND    NOT EXISTS ( SELECT 'x' FROM nm_elements c, nm_members m2
                     WHERE c.ne_id = m2.nm_ne_id_of
                     AND   m2.nm_ne_id_in = c_ne_id
                     AND   c.ne_id != s.ne_id
                     AND DECODE( m2.nm_cardinality, 1, c.ne_no_end, c.ne_no_start ) =
                         DECODE( m1.nm_cardinality, 1, s.ne_no_start, s.ne_no_end ));

CURSOR group_nt_type_c IS
  SELECT
    nng_nt_type
  FROM
    nm_nt_groupings
  WHERE
    nng_group_type = Nm3net.get_gty_type(p_ne_id);
l_group_nt_type nm_nt_groupings.nng_nt_type%TYPE;

l_offset_st     NUMBER;
l_offset_end    NUMBER;
l_st_node               NUMBER;
l_end_node              NUMBER;

l_n_units nm_types.nt_length_unit%TYPE := Nm3net.get_nt_units(Nm3net.Get_Nt_Type(p_ne_id));

BEGIN
  Nm_Debug.proc_start(g_package_name,'set_route_offsets');
  OPEN group_nt_type_c;
    FETCH group_nt_type_c INTO l_group_nt_type;
  CLOSE group_nt_type_c;

  --get base units of elements
  g_e_units := Nm3net.get_nt_units(l_group_nt_type);

  --set initial offset in base units of elements
  l_offset_st := Nm3unit.convert_unit(l_n_units, g_e_units, p_offset_st);

--  create a table of returned elements with their lengths, start nodes and end nodes
--  also create a table of offsets

  g_tree_index := 0;

  FOR st_rec IN get_start( p_ne_id ) LOOP

    -- dbms_output.put_line( 'NEW START' );
    -- dbms_output.put_line( TO_CHAR( st_rec.ne_id )||' '||st_rec.end_node||' '||TO_CHAR(st_rec.ne_length));

    l_offset_end := l_offset_st + st_rec.ne_length;

    IF st_rec.CARDINALITY = 1 THEN
      l_st_node  := st_rec.st_node;
      l_end_node := st_rec.end_node;
    ELSE
      l_end_node := st_rec.st_node;
      l_st_node  := st_rec.end_node;
    END IF;

    g_tree_index := g_tree_index + 1;
    set_tree ( st_rec.ne_id, l_st_node, l_end_node, st_rec.ne_length, l_offset_st);

    l_offset_end := l_offset_st + st_rec.ne_length;

    recursive_tree ( p_ne_id, l_end_node, l_offset_end );

  END LOOP;
  Nm_Debug.proc_end(g_package_name,'set_route_offsets');

END;
--
-------------------------------------------------------------------------------------------
--
PROCEDURE recursive_tree (p_ne_id     IN NUMBER
                         ,p_st_node   IN VARCHAR2
                         ,p_offset_st IN NUMBER
                         ) IS
-- starting at the given node, within a given set, get the elements at the end node and repeat recursively until
-- all records are processed.

l_st_node    NUMBER;
l_end_node   NUMBER;
l_offset_st  NUMBER := p_offset_st;
l_offset_end NUMBER;
l_ne_id      NUMBER;

CURSOR cst1( c_node VARCHAR2, c_ne_id NUMBER ) IS
   SELECT ne_id, ne_length, ne_no_start st_node, ne_no_end end_node, nm_cardinality CARDINALITY FROM
   nm_elements, nm_members
   WHERE ne_id = nm_ne_id_of
   AND nm_ne_id_in = c_ne_id
   AND DECODE( nm_cardinality, 1, ne_no_start, ne_no_end ) = c_node;

BEGIN
  Nm_Debug.proc_start(g_package_name,'recursive_tree');
  -- dbms_output.put_line( 'Recursion from '||p_st_node||' in group '||TO_CHAR(p_ne_id) );
  FOR cnct_rec IN cst1( p_st_node, p_ne_id ) LOOP

    IF NOT element_in_tree( cnct_rec.ne_id ) THEN
--
--    element is not already in the tree - add it and call recursively
--
      g_tree_index := g_tree_index + 1;
      l_offset_end := l_offset_st + cnct_rec.ne_length;

      IF cnct_rec.CARDINALITY = 1 THEN
        l_st_node  := cnct_rec.st_node;
        l_end_node := cnct_rec.end_node;
      ELSE
        l_end_node := cnct_rec.st_node;
        l_st_node  := cnct_rec.end_node;
      END IF;
--
--      dbms_output.put_line( 'Idx='||TO_CHAR(g_tree_index)||' '||TO_CHAR(cnct_rec.ne_id)||' '||
--                TO_CHAR(l_st_node)||' '||TO_CHAR(l_end_node)||' '||TO_CHAR(cnct_rec.ne_length)||' '||
--                TO_CHAR(l_offset_st)||' '||TO_CHAR(l_offset_end));

      set_tree ( cnct_rec.ne_id, l_st_node, l_end_node, cnct_rec.ne_length, l_offset_st);
      recursive_tree ( p_ne_id, l_end_node, l_offset_end);
    END IF;
  END LOOP;
  Nm_Debug.proc_end(g_package_name,'recursive_tree');
END;
--
-------------------------------------------------------------------------------------------
--
FUNCTION element_in_tree( p_ne_id IN nm_elements.ne_id%TYPE ) RETURN BOOLEAN IS

retval  BOOLEAN := FALSE;
tindex  BINARY_INTEGER;

BEGIN
  Nm_Debug.proc_start(g_package_name,'element_in_tree');
  -- dbms_output.put_line('Testing '||TO_CHAR(p_ne_id)||' Index at '||TO_CHAR(g_tree_index) );
  IF g_tree_index = 0 THEN
    retval := FALSE;
  ELSE
    FOR tindex IN 1..g_tree_index LOOP
        IF p_ne_id = route_tree(tindex).r_ne_id THEN
        retval := TRUE;
        EXIT;
      END IF;
    END LOOP;
  END IF;
  Nm_Debug.proc_end(g_package_name,'element_in_tree');
  RETURN retval;
END;
--
-------------------------------------------------------------------------------------------
--
PROCEDURE set_tree (p_ne_id     IN nm_elements.ne_id%TYPE
                   ,p_st_node   IN nm_elements.ne_no_start%TYPE
                   ,p_end_node  IN nm_elements.ne_no_end%TYPE
                   ,p_length    IN nm_elements.ne_length%TYPE
                   ,p_offset_st IN nm_members.nm_slk%TYPE
                   ) IS


BEGIN
  Nm_Debug.proc_start(g_package_name,'set_tree');
  route_tree(g_tree_index).r_ne_id      := p_ne_id;
  route_tree(g_tree_index).r_st_node    := p_st_node;
  route_tree(g_tree_index).r_end_node   := p_end_node;
  route_tree(g_tree_index).r_length     := p_length;
  route_tree(g_tree_index).r_offset_st  := p_offset_st;
  Nm_Debug.proc_end(g_package_name,'set_tree');
END;
--
-------------------------------------------------------------------------------------------
--
PROCEDURE dump_tree IS

tindex BINARY_INTEGER;

BEGIN
  Nm_Debug.proc_start(g_package_name,'dump_tree');
  DBMS_OUTPUT.PUT_LINE( 'Tree contains '||TO_CHAR(g_tree_index)||' records :');

  FOR tindex IN 1..g_tree_index LOOP

  DBMS_OUTPUT.PUT_LINE( 'NE='||TO_CHAR(route_tree(tindex).r_ne_id)||' '||
                        'SN='||route_tree(tindex).r_st_node||' '||
                        'EN='||route_tree(tindex).r_end_node||' '||
                        'Len'||TO_CHAR(route_tree(tindex).r_length)||' '||
                        'St'||TO_CHAR(route_tree(tindex).r_offset_st) );
  END LOOP;
  Nm_Debug.proc_end(g_package_name,'dump_tree');
END;
--
-------------------------------------------------------------------------------------------
--
PROCEDURE get_tree_rec(p_index IN     NUMBER
                      ,p_ne_id    OUT NUMBER
                      ,p_sn       OUT NUMBER
                      ,p_en       OUT NUMBER
                      ,p_len      OUT NUMBER
                      ,p_sto      OUT NUMBER
                      ) IS
BEGIN
  Nm_Debug.proc_start(g_package_name,'get_tree_rec');
    p_ne_id := route_tree(p_index).r_ne_id;
    p_sn := route_tree(p_index).r_st_node;
    p_en := route_tree(p_index).r_end_node;
    p_len:= route_tree(p_index).r_length;
    p_sto:= route_tree(p_index).r_offset_st;
  Nm_Debug.proc_end(g_package_name,'get_tree_rec');
END;
--
-------------------------------------------------------------------------------------------
--
PROCEDURE update_route_offsets (p_ne_id    IN NUMBER
                               ,p_unit     IN NUMBER
                               ,p_seq_flag IN VARCHAR2
                               ) IS

tindex BINARY_INTEGER;
l_offset_st   NUMBER;
l_offset_end  NUMBER;

BEGIN

  Nm_Debug.proc_start(g_package_name,'update_route_offsets');

--  nm_debug.debug('Start of loop - units = '||g_e_units||' '||p_unit);

  FOR tindex IN 1..g_tree_index LOOP

    l_offset_st  := Nm3unit.convert_unit( g_e_units, p_unit, route_tree(tindex).r_offset_st);

--  nm_debug.debug(tindex||' offset '||l_offset_st );

    UPDATE nm_members
    SET nm_slk = l_offset_st,
        nm_seq_no = DECODE( p_seq_flag, 'Y', tindex, nm_seq_no )
    WHERE nm_ne_id_in = p_ne_id
    AND   nm_ne_id_of = route_tree(tindex).r_ne_id;
  END LOOP;

  Nm_Debug.proc_end(g_package_name,'update_route_offsets');

END;
--
-------------------------------------------------------------------------------------------
--
PROCEDURE resequence_route ( p_ne_id IN NUMBER ) IS

tindex BINARY_INTEGER;

BEGIN

  Nm_Debug.proc_start(g_package_name,'resequence_route');
  FOR tindex IN 1..g_tree_index LOOP

    UPDATE nm_members
    SET    nm_seq_no   = tindex
    WHERE  nm_ne_id_in = p_ne_id
    AND    nm_ne_id_of = route_tree(tindex).r_ne_id;
  END LOOP;
  Nm_Debug.proc_end(g_package_name,'resequence_route');

END;
--
-------------------------------------------------------------------------------------------
FUNCTION is_ambiguous ( p_lref IN nm_lref, p_route_units IN NUMBER, p_element_units IN NUMBER ) RETURN BOOLEAN IS
CURSOR c1 ( c_ne_id nm_elements.ne_id%TYPE
           ,c_offset nm_elements.ne_length%TYPE
           ,c_route_units   NUMBER
           ,c_element_units NUMBER ) IS
  SELECT COUNT(*)
  FROM   nm_elements s
        ,nm_members  m
  WHERE  s.ne_id       = m.nm_ne_id_of
  AND    m.nm_ne_id_in = c_ne_id
  AND    c_offset >= m.nm_slk
  AND    c_offset <  m.nm_slk + Nm3unit.convert_unit(c_element_units ,c_route_units ,NVL(m.nm_end_mp, s.ne_length) - nm_begin_mp  );

retval BOOLEAN;
l_dummy NUMBER;
BEGIN
  OPEN c1 ( p_lref.lr_ne_id, p_lref.lr_offset, p_route_units, p_element_units );
  FETCH c1 INTO l_dummy;
  CLOSE c1;
  IF l_dummy > 1 THEN
    retval := TRUE;
  ELSE
    retval := FALSE;
  END IF;
  RETURN retval;
END;
--
-- this function derives a set of placements from a start and end of a parent placement. Note that offsets in the
-- placement are provided in the units of the type of network element.
FUNCTION  get_sub_placement ( p_pl IN nm_placement ) RETURN nm_placement_array IS
--
CURSOR get_start (c_ne_id         NUMBER
                 ,c_start         NUMBER
				 ,c_end           NUMBER
                 ,c_route_units   NUMBER
                 ,c_element_units NUMBER
                 ) IS
  SELECT s.ne_id       ne_id
        ,s.ne_no_start st_node
        ,s.ne_no_end   end_node
        ,s.ne_length   ne_length
        ,m.nm_slk
		,m.nm_begin_mp begin_mp
		,NVL(m.nm_end_mp,s.ne_length)   end_mp
        ,m.nm_cardinality
  FROM   nm_elements s
        ,nm_members  m
  WHERE  s.ne_id       = m.nm_ne_id_of
  AND    m.nm_ne_id_in = c_ne_id
  AND    c_start >= m.nm_slk
  AND    c_start <   m.nm_slk + Nm3unit.convert_unit(c_element_units, c_route_units,
				                        ( NVL(m.nm_end_mp, s.ne_length) - m.nm_begin_mp));
--
l_offset_st       NUMBER;
l_p_next_offset   NUMBER;
l_s_offset_end    NUMBER;
l_node            NUMBER;
--
l_current_mem_end NUMBER;
--
l_route_nt_type   nm_elements.ne_nt_type%TYPE;
l_route_gty       nm_elements.ne_gty_group_type%TYPE;
--
l_conv_value      NUMBER;
--
BEGIN
--
--nm_debug.debug_on;
  Nm_Debug.proc_start(g_package_name,'get_sub_placement');


  g_pl := initialise_placement_array;

  -- just return the placement array passed if the ne_id is a datum element.
  IF Nm3net.is_nt_datum(Nm3net.Get_Nt_Type(p_pl.pl_ne_id)) = 'Y' THEN
     add_element_to_pl_arr(g_pl,p_pl);
     RETURN g_pl;
  END IF;

  l_route_nt_type := Nm3net.Get_Nt_Type (p_pl.pl_ne_id);
  l_route_gty     := Nm3net.get_gty_type( p_pl.pl_ne_id );
--
  Nm3net.get_group_units( p_pl.pl_ne_id, g_route_unit, g_element_unit );

  IF is_ambiguous( nm_lref( p_pl.pl_ne_id, p_pl.pl_start ), g_route_unit, g_element_unit ) THEN
    RAISE_APPLICATION_ERROR(-20002, 'Ambiguous starting linear reference');
  END IF;

/*
  g_route_unit    := nm3net.get_nt_units( l_route_nt_type );
  g_element_unit  := nm3net.get_nt_units( nm3net.get_datum_nt(l_route_nt_type));
*/
--
--
  l_offset_st := p_pl.pl_start;
--
--we only expect a single start position, but leave this in as it may be expanded to
--include an ambiguous starting point.
--
  FOR st_rec IN get_start( p_pl.pl_ne_id, p_pl.pl_start, p_pl.pl_end, g_route_unit, g_element_unit)
   LOOP

--   nm_debug.debug( 'Start element = '||to_char(st_rec.ne_id));
--   if the rowcount > 1 and its a point item, then it has been dealt with

     IF get_start%rowcount > 1 AND p_pl.pl_end = p_pl.pl_start THEN
	   EXIT;
     END IF;

--   convert the start offset to a datum position

     l_conv_value := Nm3unit.convert_unit(g_route_unit, g_element_unit ,p_pl.pl_start - st_rec.nm_slk );

 --
     IF st_rec.nm_cardinality = 1
      THEN
        l_offset_st :=  l_conv_value +  st_rec.begin_mp;
        l_s_offset_end := NVL(st_rec.end_mp, st_rec.ne_length);
        l_conv_value := Nm3unit.convert_unit( g_element_unit, g_route_unit, l_s_offset_end - st_rec.begin_mp );
     ELSE
        l_offset_st :=  NVL(st_rec.end_mp, st_rec.ne_length) - l_conv_value;
        l_s_offset_end := st_rec.begin_mp;
        l_conv_value := Nm3unit.convert_unit( g_element_unit, g_route_unit, st_rec.end_mp - l_s_offset_end );
     END IF;
 --
     l_current_mem_end := st_rec.nm_slk + l_conv_value;
--
--     nm_debug.debug( 'NEW START' );
--     nm_debug.debug( TO_CHAR( st_rec.ne_id )||' '||st_rec.end_node||' '||TO_CHAR(st_rec.ne_length));
--
--     nm_debug.debug( 'End '||TO_CHAR(p_pl.pl_end)||' Offset '||TO_CHAR(l_p_next_offset));
--
--     nm_debug.debug( 'Comparing '||to_char(p_pl.pl_end)||' and '||to_char(l_current_mem_end));

	 IF p_pl.pl_end <= l_current_mem_end
     THEN
--        nm_debug.debug( 'Only need look at first element');

  --
  --    The placement range only consists of a single sub-element id record (unless the placement has more than one start)
  --
        l_conv_value   := Nm3unit.convert_unit(g_route_unit
                                              ,g_element_unit
											  ,p_pl.pl_end - st_rec.nm_slk );
--        nm_debug.debug( to_char( l_conv_value ));
  --
        IF st_rec.nm_cardinality = 1
         THEN
           l_s_offset_end := l_conv_value + st_rec.begin_mp;
           add_element_to_pl_arr (pio_pl_arr => g_pl
                                 ,pi_ne_id   => st_rec.ne_id
                                 ,pi_start   => l_offset_st
                                 ,pi_end     => l_s_offset_end
                                 ,pi_measure => 0
                                 ,pi_mrg_mem => FALSE
                                 );
        ELSE
           l_s_offset_end :=  st_rec.end_mp - l_conv_value;
           add_element_to_pl_arr (pio_pl_arr => g_pl
                                 ,pi_ne_id   => st_rec.ne_id
                                 ,pi_start   => l_s_offset_end
                                 ,pi_end     => l_offset_st
                                 ,pi_measure => 0
                                 ,pi_mrg_mem => FALSE
                                 );
        END IF;
 --
     ELSE
 --
        IF st_rec.nm_cardinality = 1
         THEN
           l_s_offset_end := st_rec.ne_length;
           add_element_to_pl_arr (pio_pl_arr => g_pl
                                 ,pi_ne_id   => st_rec.ne_id
                                 ,pi_start   => l_offset_st
                                 ,pi_end     => l_s_offset_end
                                 ,pi_measure => 0
                                 ,pi_mrg_mem => FALSE
                                 );
           l_node := st_rec.end_node;
           l_p_next_offset := l_s_offset_end - l_offset_st;

        ELSE
--         l_offset_st := st_rec.ne_length - l_offset_st;
           l_s_offset_end := 0;
           add_element_to_pl_arr (pio_pl_arr => g_pl
                                 ,pi_ne_id   => st_rec.ne_id
                                 ,pi_start   => l_s_offset_end
                                 ,pi_end     => l_offset_st
                                 ,pi_measure => 0
                                 ,pi_mrg_mem => FALSE
                                 );
           l_node := st_rec.st_node;
           l_p_next_offset := l_offset_st - l_s_offset_end;

        END IF;
  --
        l_p_next_offset := Nm3unit.convert_unit
                                         (g_element_unit
                                         ,g_route_unit
                                         ,l_p_next_offset
                                         );
        recursive_placement ( p_pl, l_node, l_p_next_offset );
 --
     END IF;
--
  END LOOP;

--
  Nm_Debug.proc_end(g_package_name,'get_sub_placement');
--nm_debug.debug_off;
  RETURN g_pl;
--
END get_sub_placement;
--
-------------------------------------------------------------------------------------------
--
PROCEDURE recursive_placement (p_pl     IN nm_placement
                              ,p_node   IN NUMBER
                              ,p_offset IN NUMBER
                              ) IS
--
CURSOR get_next ( c_ne_id NUMBER, c_node NUMBER ) IS
  SELECT s.ne_id ne_id, s.ne_no_start st_node, s.ne_no_end end_node,
         s.ne_length ne_length, m.nm_slk, m.nm_cardinality
  FROM nm_elements s, nm_members m
  WHERE  s.ne_id = m.nm_ne_id_of
  AND    m.nm_ne_id_in = c_ne_id
  AND    s.ne_id NOT IN ( SELECT pl.pl_ne_id
                          FROM TABLE( g_pl.npa_placement_array ) pl )
  AND    c_node = DECODE( m.nm_cardinality, 1, s.ne_no_start, s.ne_no_end );
--
l_offset_st       NUMBER;
l_p_next_offset   NUMBER;
l_s_offset_end    NUMBER;
l_node            NUMBER;
--
l_current_mem_end NUMBER;
--
BEGIN
--
--  nm_debug.debug('recursive '||p_pl.pl_ne_id||':'||p_pl.pl_start||'->'||p_pl.pl_end||'...'||p_node||'-'||p_offset);
--
  FOR st_rec IN get_next ( p_pl.pl_ne_id, p_node )
   LOOP
 --
     IF st_rec.nm_cardinality = 1 THEN
       l_offset_st    := 0;
       l_s_offset_end := st_rec.ne_length;
     ELSE
       l_offset_st    := st_rec.ne_length;
       l_s_offset_end := 0;
     END IF;
 --
     l_current_mem_end := Nm3lrs.get_set_offset( p_pl.pl_ne_id, st_rec.ne_id, l_s_offset_end );
 --
     IF l_current_mem_end >= p_pl.pl_end
      THEN
 --
 --    we have reached the end of the recursive trace, find the sub-offset.
 --
        l_s_offset_end := Nm3unit.convert_unit(g_route_unit
                                              ,g_element_unit
                                              ,(p_pl.pl_end - st_rec.nm_slk)
                                              );
 --
        IF st_rec.nm_cardinality = 1
         THEN
           add_element_to_pl_arr (pio_pl_arr => g_pl
                                 ,pi_ne_id   => st_rec.ne_id
                                 ,pi_start   => l_offset_st
                                 ,pi_end     => l_s_offset_end
                                 ,pi_measure => p_offset
                                 ,pi_mrg_mem => FALSE
                                 );
        ELSE
           l_s_offset_end := st_rec.ne_length - l_s_offset_end;
           add_element_to_pl_arr (pio_pl_arr => g_pl
                                 ,pi_ne_id   => st_rec.ne_id
                                 ,pi_start   => l_s_offset_end
                                 ,pi_end     => l_offset_st
                                 ,pi_measure => p_offset
                                 ,pi_mrg_mem => FALSE
                                 );
        END IF;
 --
     ELSE
 --
        IF st_rec.nm_cardinality = 1 THEN
           l_s_offset_end := st_rec.ne_length;
           add_element_to_pl_arr (pio_pl_arr => g_pl
                                 ,pi_ne_id   => st_rec.ne_id
                                 ,pi_start   => l_offset_st
                                 ,pi_end     => l_s_offset_end
                                 ,pi_measure => p_offset
                                 ,pi_mrg_mem => FALSE
                                 );
        ELSE
          l_s_offset_end := 0;
           add_element_to_pl_arr (pio_pl_arr => g_pl
                                 ,pi_ne_id   => st_rec.ne_id
                                 ,pi_start   => l_s_offset_end
                                 ,pi_end     => l_offset_st
                                 ,pi_measure => p_offset
                                 ,pi_mrg_mem => FALSE
                                 );
        END IF;
  --
        IF st_rec.nm_cardinality = 1 THEN
          l_node := st_rec.end_node;
        ELSE
          l_node := st_rec.st_node;
        END IF;
  --
        l_p_next_offset := Nm3unit.convert_unit(g_element_unit
                                               ,g_route_unit
                                               ,st_rec.ne_length
                                               ) + p_offset;
        recursive_placement ( p_pl, l_node, l_p_next_offset );
 --
     END IF;
--
  END LOOP;
--
END recursive_placement;
--
-------------------------------------------------------------------------------------------
--
FUNCTION  get_super_placement(p_pl_array IN nm_placement_array
                             ,p_type     IN VARCHAR2
                             ) RETURN nm_placement_array IS

st_flag     BOOLEAN := TRUE;
l_pl_array  nm_placement_array;
l_pl        nm_placement;
l_st        NUMBER;
l_end       NUMBER;
l_measure   NUMBER;
l_p_unit    NUMBER := Nm3net.get_nt_units( p_type );
l_c_unit    NUMBER;

CURSOR c1( c_ne_id NUMBER, c_type VARCHAR2) IS
  SELECT nm_ne_id_in, nm_slk, nm_cardinality, s.ne_no_start, s.ne_no_end, s.ne_nt_type, s.ne_length
  FROM nm_members, nm_elements r, nm_elements s
  WHERE nm_ne_id_of = c_ne_id
  AND   s.ne_id = c_ne_id
  AND   r.ne_nt_type = c_type
  AND   r.ne_id  = nm_ne_id_in
  order by r.ne_id;

l_ne_id_of     NUMBER;
l_ne_id_in1    NUMBER;
l_slk1         NUMBER;
l_cardinality1 NUMBER;
l_st_node1     NUMBER;
l_end_node1    NUMBER;
l_nt_type1     VARCHAR2(4);
l_length1    number;


l_ne_id_in2    NUMBER;
l_slk2         NUMBER;
l_cardinality2 NUMBER;
l_st_node2     NUMBER;
l_end_node2    NUMBER;
l_nt_type2     VARCHAR2(4);
l_length2    number;
l_connected BOOLEAN := FALSE;

l_pl_index NUMBER := 1;

BEGIN
--  nm_debug.debug_on;
  Nm_Debug.proc_start(g_package_name,'get_super_placement');
  l_pl       := nm3pla.initialise_placement;          --nm_placement(null, null, null, null);
  l_pl_array := nm3pla.initialise_placement_array;

  FOR ip IN 1..p_pl_array.placement_count LOOP

    l_ne_id_of := p_pl_array.npa_placement_array(ip).pl_ne_id;

    IF st_flag THEN

--    get the start offset of the first element in the array, relative to the type of route.
--    This is only valid for exclusive set types.

      OPEN c1 (l_ne_id_of, p_type);
      FETCH c1 INTO l_ne_id_in1, l_slk1, l_cardinality1, l_st_node1, l_end_node1, l_nt_type1, l_length1;
      IF c1%NOTFOUND THEN
        CLOSE c1;
        RAISE_APPLICATION_ERROR( -20001, 'First element of placement is not included in a set of this type' );
      END IF;
      CLOSE c1;
--
      l_c_unit := Nm3net.get_nt_units( l_nt_type1 );

      if l_cardinality1 > 0 then
        l_st  := l_slk1  + Nm3unit.convert_unit( l_c_unit, l_p_unit, p_pl_array.npa_placement_array(ip).pl_start );
        l_end := l_slk1 +  Nm3unit.convert_unit( l_c_unit, l_p_unit, p_pl_array.npa_placement_array(ip).pl_end  );
      else
        l_st  := l_slk1 + Nm3unit.convert_unit( l_c_unit, l_p_unit, l_length1 - p_pl_array.npa_placement_array(ip).pl_end );
        l_end := l_slk1 +  Nm3unit.convert_unit( l_c_unit, l_p_unit, l_length1 -  p_pl_array.npa_placement_array(ip).pl_start  );
      end if;
            
      l_measure := 0;

      l_pl := nm_placement( l_ne_id_in1, l_st, l_end, l_measure );

--     nm_debug.debug( 'First array element ar start = '||to_char( l_ne_id_in1 )||','||to_char(l_st)||
--                          ','||to_char(l_end)||','||to_char(l_measure));

--
    ELSE

--    for each element, get the parent element and its offsets, cardinality, start and end nodes and
--    compare with the previous. If the parent is the same and there is connectivity, then extend the
--    placement element.

      OPEN c1 ( l_ne_id_of, p_type);
      FETCH c1 INTO l_ne_id_in2, l_slk2, l_cardinality2, l_st_node2, l_end_node2, l_nt_type2, l_length2;
      IF c1%NOTFOUND THEN
        CLOSE c1;
        RAISE_APPLICATION_ERROR( -20001, 'Element '||TO_CHAR(ip)||' of placement is not included in a set of this type' );
      END IF;
      CLOSE c1;

      IF l_ne_id_in1 = l_ne_id_in2 THEN
--
--      check connectivity
--
        l_connected := FALSE;

        IF l_cardinality1 = 1 THEN
          IF l_cardinality2 = 1 THEN
--          e to s
            IF l_end_node1 = l_st_node2 THEN
              l_connected := TRUE;
            END IF;
          ELSE
--          e to e
            IF l_end_node1 = l_end_node2 THEN
              l_connected := TRUE;
            END IF;
          END IF;
        ELSE
          IF l_cardinality2 = 1 THEN
--          s to s
            IF l_st_node1 = l_st_node2 THEN
              l_connected := TRUE;
            END IF;
          ELSE
--          s to e
            IF l_st_node1 = l_end_node2 THEN
              l_connected := TRUE;
            END IF;
          END IF;
        END IF;

        IF l_connected THEN
--
--        extend placement
--
          l_end := l_slk2 +  Nm3unit.convert_unit( l_c_unit, l_p_unit, p_pl_array.npa_placement_array(ip).pl_end - p_pl_array.npa_placement_array(ip).pl_start  );

          l_pl := nm_placement( l_ne_id_in1, l_st, l_end, l_measure );
--        nm_debug.debug( 'Connected - array element = '||to_char( l_ne_id_in1 )||','||to_char(l_st)||0||
--                              ','||to_char(l_end)||','||to_char(l_measure));

        ELSE

--
---       nm_debug.debug('start new placement');
--
          if l_pl_array.npa_placement_array.count < l_pl_index then
          
             l_pl_array.npa_placement_array.extend;

          end if;
          
          l_pl_array.npa_placement_array( l_pl_index ) := l_pl;
        
          l_pl_index := l_pl_index + 1;
        
          if l_cardinality1 > 0 then
            l_st  := l_slk2  + Nm3unit.convert_unit( l_c_unit, l_p_unit, p_pl_array.npa_placement_array(ip).pl_start );
            l_end := l_slk2 +  Nm3unit.convert_unit( l_c_unit, l_p_unit, p_pl_array.npa_placement_array(ip).pl_end  );
          else
            l_st  := l_slk2 + Nm3unit.convert_unit( l_c_unit, l_p_unit, l_length2 - p_pl_array.npa_placement_array(ip).pl_end );
            l_end := l_slk2+  Nm3unit.convert_unit( l_c_unit, l_p_unit, l_length2 -  p_pl_array.npa_placement_array(ip).pl_start  );
         end if;

          l_pl := nm_placement( l_ne_id_in2, l_st, l_end, l_measure );
--
        END IF;
      ELSE
--
          if l_pl_array.npa_placement_array.count < l_pl_index then
          
             l_pl_array.npa_placement_array.extend;

          end if;

          l_pl_array.npa_placement_array( l_pl_index ) := l_pl;
        
          l_pl_index := l_pl_index + 1;
        
           if l_cardinality1 > 0 then
             l_st  := l_slk2  + Nm3unit.convert_unit( l_c_unit, l_p_unit, p_pl_array.npa_placement_array(ip).pl_start );
             l_end := l_slk2 +  Nm3unit.convert_unit( l_c_unit, l_p_unit, p_pl_array.npa_placement_array(ip).pl_end  );
           else
             l_st  := l_slk2 + Nm3unit.convert_unit( l_c_unit, l_p_unit, l_length2 - p_pl_array.npa_placement_array(ip).pl_end );
             l_end := l_slk2 +  Nm3unit.convert_unit( l_c_unit, l_p_unit, l_length2 -  p_pl_array.npa_placement_array(ip).pl_start  );
          end if;

          l_pl := nm_placement( l_ne_id_in2, l_st, l_end, l_measure );

--      nm_debug.debug('loss of connectivity - start a new array element');
--
        
      END IF;
    END IF;

--  move to the next record
    IF st_flag THEN
      st_flag := FALSE;
    ELSE
      l_ne_id_in1    := l_ne_id_in2;
      l_slk1         := l_slk2;
      l_cardinality1 := l_cardinality2;
      l_st_node1     := l_st_node2;
      l_end_node1    := l_end_node2;
      l_length1     := l_length2;
    END IF;
--
  END LOOP;
--
--if we are here, we have to set the last element of the array.
--
  if l_pl_array.npa_placement_array.count < l_pl_index then
          
     l_pl_array.npa_placement_array.extend;

  end if;


  l_pl_array.npa_placement_array( l_pl_index ) := l_pl;
--
  Nm_Debug.proc_end(g_package_name,'get_super_placement');
  RETURN l_pl_array;
--
END;
--
--
-------------------------------------------------------------------------------------------
--
/*
function  get_super_placement( p_ne_id_in in number, p_type in varchar2 ) return nm_placement_array is
--
  l_pl nm_placement_array := initialise_placement_array;
--
begin
  l_pl := get_super_placement( l_pl, p_type ).npa_placement_array;
  return l_pl;
end;
*/
--
-------------------------------------------------------------------------------------------
--
FUNCTION Get_Placement_From_Ne( p_ne_id_in IN NUMBER) RETURN nm_placement_array IS
--
   CURSOR c1 (c_ne_id nm_members.nm_ne_id_in%TYPE) IS
   SELECT nm_ne_id_of
         ,nm_begin_mp
         ,nm_end_mp
         ,nm_slk
    FROM  nm_members
   WHERE  nm_ne_id_in = c_ne_id
   ORDER BY nm_seq_no;
--
   l_pl nm_placement_array := Nm3pla.initialise_placement_array;
--
   l_ne_row nm_elements_all%ROWTYPE;
   
BEGIN

  l_ne_row:= Nm3get.get_ne( p_ne_id_in, FALSE );   

--
  Nm_Debug.proc_start(g_package_name,'get_placement_from_ne');
   IF l_ne_row.ne_id IS NOT NULL AND Nm3net.is_nt_datum( l_ne_row.ne_nt_type ) = 'Y' THEN
     l_pl := nm_placement_array( nm_placement_array_type( nm_placement( p_ne_id_in, 0, l_ne_row.ne_length , 0)));
   ELSE     
     FOR irec IN c1 (p_ne_id_in)
      LOOP
--
           Nm3pla.add_element_to_pl_arr (pio_pl_arr => l_pl
                                 ,pi_ne_id   => irec.nm_ne_id_of
                                 ,pi_start   => irec.nm_begin_mp
                                 ,pi_end     => irec.nm_end_mp
                                 ,pi_measure => 0
                                 ,pi_mrg_mem => TRUE
                                 );
--
     END LOOP;
--
  END IF;
  Nm_Debug.proc_end(g_package_name,'get_placement_from_ne');
   RETURN l_pl;
--
END Get_Placement_From_Ne;
--
-------------------------------------------------------------------------------------------
--
FUNCTION get_placement_from_temp_ne( p_ne_id_in IN NUMBER) RETURN nm_placement_array IS
--
  l_pl nm_placement_array := initialise_placement_array;
--
BEGIN
--
  Nm_Debug.proc_start(g_package_name,'get_placement_from_temp_ne');
  FOR irec IN (SELECT nte_ne_id_of
                     ,nte_begin_mp
                     ,nte_end_mp
                FROM  nm_nw_temp_extents
               WHERE  nte_job_id = p_ne_id_in
               ORDER BY nte_seq_no
              )
   LOOP
           add_element_to_pl_arr (pio_pl_arr => l_pl
                                 ,pi_ne_id   => irec.nte_ne_id_of
                                 ,pi_start   => irec.nte_begin_mp
                                 ,pi_end     => irec.nte_end_mp
                                 ,pi_measure => 0
                                 ,pi_mrg_mem => TRUE
                                 );
  END LOOP;
  Nm_Debug.proc_end(g_package_name,'get_placement_from_temp_ne');
--
  RETURN l_pl;
--
END get_placement_from_temp_ne;
--
-------------------------------------------------------------------------------------------
--
FUNCTION get_placement_persistent_ne( p_ne_id_in IN NUMBER) RETURN nm_placement_array IS
--
  l_pl nm_placement_array := initialise_placement_array;
--
BEGIN
--
  Nm_Debug.proc_start(g_package_name,'get_placement_persistent_ne');
  FOR irec IN (SELECT npe_ne_id_of
                     ,npe_begin_mp
                     ,npe_end_mp
                FROM  nm_nw_persistent_extents
               WHERE  npe_job_id = p_ne_id_in
               ORDER BY npe_seq_no
              )
   LOOP
           add_element_to_pl_arr (pio_pl_arr => l_pl
                                 ,pi_ne_id   => irec.npe_ne_id_of
                                 ,pi_start   => irec.npe_begin_mp
                                 ,pi_end     => irec.npe_end_mp
                                 ,pi_measure => 0
                                 ,pi_mrg_mem => TRUE
                                 );
  END LOOP;
  Nm_Debug.proc_end(g_package_name,'get_placement_persistent_ne');
--
  RETURN l_pl;
--
END get_placement_persistent_ne;
--
-------------------------------------------------------------------------------------------
--
FUNCTION defrag_placement_array (this_npa nm_placement_array) RETURN nm_placement_array IS
--
   new_npa       nm_placement_array;
--
   prior_ne_id   NUMBER;
   prior_start   NUMBER;
   prior_end     NUMBER;
   prior_measure NUMBER;
   prior_length  NUMBER;
   measure       NUMBER;
--
   l_end         NUMBER;
   l_this_ne_id  NUMBER;
--
   l_array_count NUMBER;
   l_length      NUMBER;
   l_connect     INTEGER;
--
BEGIN
--
--   nm_debug.proc_start(g_package_name,'defrag_placement_array');
   l_array_count := this_npa.placement_count;
--
-- If Placement array empty or only contains one record then return as is
--
   new_npa := Nm3pla.initialise_placement_array;
--
   IF l_array_count <= 1
    THEN
      new_npa := this_npa;
   ELSE
--
      prior_ne_id   := NVL(this_npa.npa_placement_array(1).pl_ne_id,0);
      prior_start   := NVL(this_npa.npa_placement_array(1).pl_start,0);
      prior_end     := NVL(this_npa.npa_placement_array(1).pl_end,0);
      prior_measure := NVL(this_npa.npa_placement_array(1).pl_measure,0);
      prior_length :=  Nm3net.get_datum_element_length(prior_ne_id);
   --
      measure       := 0;
   --

      FOR l_counter IN 1..this_npa.placement_count
       LOOP
   --
         l_this_ne_id := NVL(this_npa.npa_placement_array(l_counter).pl_ne_id,0);
   --
         IF l_this_ne_id <> prior_ne_id
          THEN -- This is for a different NE_ID
   --
--            l_end := this_npa.npa_placement_array(l_counter-1).pl_end;
            l_end := prior_end;
   --
           add_element_to_pl_arr (pio_pl_arr => new_npa
                                 ,pi_ne_id   => prior_ne_id
                                 ,pi_start   => prior_start
                                 ,pi_end     => l_end
                                 ,pi_measure => measure
                                 ,pi_mrg_mem => TRUE
                                 );
   --
            l_length  := Nm3net.get_datum_element_length(l_this_ne_id);
            l_connect := defrag_connectivity(prior_ne_id, l_this_ne_id);
--          nm_debug.debug( 'L-connect'||TO_CHAR(l_connect));
--          nm_debug.debug( 'Current length '||TO_CHAR(l_length) );
--          nm_debug.debug( 'Current end '||this_npa.npa_placement_array(l_counter).pl_end );
--          nm_debug.debug( 'Current start '||this_npa.npa_placement_array(l_counter).pl_start );
--          nm_debug.debug( 'Prior length '||TO_CHAR(prior_length) );

            measure := measure + (l_end - prior_start);
--
            IF Nm3net.subclass_is_used (l_this_ne_id) AND
               Nm3net.get_sub_class(l_this_ne_id) != Nm3net.get_sub_class(prior_ne_id)
             THEN
               IF    l_connect = 1
                THEN
                  IF (prior_end <> prior_length
                      OR this_npa.npa_placement_array(l_counter).pl_start <>0
                     )
                   THEN
                     measure := 0;
                  END IF;
               ELSE
                  measure := 0;
               END IF;
            ELSIF   l_connect = 0
            THEN
              measure := 0;
            ELSIF l_connect = 1  --elements in pla have diff. connected node types with a S in 2
             THEN
              IF prior_end <> prior_length OR
                 this_npa.npa_placement_array(l_counter).pl_start <>0 THEN
                measure := 0;
              END IF;
            ELSIF l_connect = 2  --elements in pla have diff. connected node types with an S in 2
             THEN
              IF this_npa.npa_placement_array(l_counter).pl_start <> 0 OR
                 prior_start <> 0 THEN
                measure := 0;
              END IF;
            ELSIF l_connect = -1 THEN  --elements in pla have same connected node types with a S in 1
              IF prior_start <> 0 OR this_npa.npa_placement_array(l_counter).pl_end <> l_length THEN
                measure := 0;
              END IF;
            ELSIF l_connect = -2 THEN  --elements in pla have same connected node types with an E in 2
              IF l_length <> this_npa.npa_placement_array(l_counter).pl_end OR
                 prior_length <> prior_end THEN
                measure := 0;
              END IF;
            ELSE  -- Crap !!!
              measure := 0;
            END IF;

            prior_ne_id   := NVL(this_npa.npa_placement_array(l_counter).pl_ne_id,0);
            prior_start   := NVL(this_npa.npa_placement_array(l_counter).pl_start,0);
            prior_end     := NVL(this_npa.npa_placement_array(l_counter).pl_end,0);
            prior_measure := NVL(this_npa.npa_placement_array(l_counter).pl_measure,0);
            prior_length :=  l_length;
   --
         ELSIF this_npa.npa_placement_array(l_counter).pl_start > this_npa.npa_placement_array(GREATEST(l_counter-1,1)).pl_end
          THEN -- This is a "hole" in the current NE_ID
   --
           add_element_to_pl_arr (pio_pl_arr => new_npa
                                 ,pi_ne_id   => prior_ne_id
                                 ,pi_start   => prior_start
                                 ,pi_end     => prior_end
                                 ,pi_measure => measure
                                 ,pi_mrg_mem => TRUE
                                 );
   --
            prior_ne_id   := NVL(this_npa.npa_placement_array(l_counter).pl_ne_id,0);
            prior_start   := NVL(this_npa.npa_placement_array(l_counter).pl_start,0);
            prior_end     := NVL(this_npa.npa_placement_array(l_counter).pl_end,0);
            prior_measure := NVL(this_npa.npa_placement_array(l_counter).pl_measure,0);
   --
            measure := 0;
   --
         ELSE
            -- This bit is connected to the last chunk in the same NE_ID
            prior_end     := GREATEST(this_npa.npa_placement_array(l_counter).pl_end,prior_end);
         END IF;
   --
      END LOOP;
   --
           add_element_to_pl_arr (pio_pl_arr => new_npa
                                 ,pi_ne_id   => prior_ne_id
                                 ,pi_start   => prior_start
                                 ,pi_end     => this_npa.npa_placement_array(l_array_count).pl_end
                                 ,pi_measure => measure
                                 ,pi_mrg_mem => TRUE
                                 );
   END IF;
--
--   nm_debug.proc_end(g_package_name,'defrag_placement_array');
   RETURN new_npa;
--
END defrag_placement_array;
--
-------------------------------------------------------------------------------------------
--
FUNCTION initialise_placement_array (pi_ne_id   IN NUMBER DEFAULT NULL
                                    ,pi_start   IN NUMBER DEFAULT NULL
                                    ,pi_end     IN NUMBER DEFAULT NULL
                                    ,pi_measure IN NUMBER DEFAULT NULL
                                    ) RETURN nm_placement_array IS
--
   this_npa nm_placement_array;
--
BEGIN
--
  Nm_Debug.proc_start(g_package_name,'initialise_placement_array');
   this_npa := nm_placement_array(nm_placement_array_type(nm_placement(pi_ne_id
                                                                      ,pi_start
                                                                      ,pi_end
                                                                      ,pi_measure
                                                                      )
                                                         )
                                 );
  Nm_Debug.proc_end(g_package_name,'initialise_placement_array');
--
   RETURN this_npa;
--
END initialise_placement_array;
--
-------------------------------------------------------------------------------------------
--
FUNCTION initialise_placement_arr_type (pi_ne_id   IN NUMBER DEFAULT NULL
                                       ,pi_start   IN NUMBER DEFAULT NULL
                                       ,pi_end     IN NUMBER DEFAULT NULL
                                       ,pi_measure IN NUMBER DEFAULT NULL
                                       ) RETURN nm_placement_array_type IS
--
   this_npat nm_placement_array_type;
--
BEGIN
--
  Nm_Debug.proc_start(g_package_name,'initialise_placement_arr_type');
   this_npat := nm_placement_array_type(nm_placement(pi_ne_id
                                                    ,pi_start
                                                    ,pi_end
                                                    ,pi_measure
                                                    )
                                       );
  Nm_Debug.proc_end(g_package_name,'initialise_placement_arr_type');
--
   RETURN this_npat;
--
END initialise_placement_arr_type;
--
-------------------------------------------------------------------------------------------
--
FUNCTION initialise_placement (pi_ne_id   IN NUMBER DEFAULT NULL
                              ,pi_start   IN NUMBER DEFAULT NULL
                              ,pi_end     IN NUMBER DEFAULT NULL
                              ,pi_measure IN NUMBER DEFAULT NULL
                              ) RETURN nm_placement IS
--
   this_np nm_placement;
--
BEGIN
--
  Nm_Debug.proc_start(g_package_name,'initialise_placement');
   this_np := nm_placement(pi_ne_id,pi_start,pi_end,pi_measure);
  Nm_Debug.proc_end(g_package_name,'initialise_placement');
--
   RETURN this_np;
--
END initialise_placement;
--
------------------------------------------------------------------------------------------------
--
FUNCTION pop_sub_placement_array(pi_ne_id IN nm_elements.ne_id%TYPE
                                  ,pi_start IN nm_elements.ne_no_start%TYPE
                                                                  ,pi_end   IN nm_elements.ne_no_end%TYPE
                                                                  ) RETURN PLS_INTEGER IS

BEGIN

  Nm_Debug.proc_start(g_package_name,'pop_sub_placement_array');
  g_pl := Nm3pla.get_sub_placement(nm_placement(pi_ne_id
                                               ,pi_start
                                               ,pi_end
                                               ,0));
  Nm_Debug.proc_end(g_package_name,'pop_sub_placement_array');
  RETURN g_pl.npa_placement_array.COUNT;

END pop_sub_placement_array;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE return_placement(pi_index   IN     NUMBER
                          ,po_ne_id      OUT NUMBER
                          ,po_start      OUT NUMBER
                          ,po_end        OUT NUMBER
                          ,po_measure    OUT NUMBER
                          ) IS
   l_placement nm_placement;
BEGIN
--
  Nm_Debug.proc_start(g_package_name,'return_placement');
  --
  l_placement := g_pl.get_entry(pi_index);
  --
  po_ne_id   := l_placement.pl_ne_id;
  po_start   := l_placement.pl_start;
  po_end     := l_placement.pl_end;
  po_measure := l_placement.pl_measure;
  --
  Nm_Debug.proc_end(g_package_name,'return_placement');
--
END return_placement;
--
------------------------------------------------------------------------------------------------
--
FUNCTION  split_placement_array (this_npa    IN     nm_placement_array
                                ,pi_ne_id    IN     nm_members.nm_ne_id_of%TYPE
                                ,pi_mp       IN     nm_members.nm_begin_mp%TYPE
                                ) RETURN nm_placement_array IS
--
   l_retval nm_placement_array := initialise_placement_array;
--
   l_current nm_placement;
   l_measure_subtract NUMBER := 0;
--
BEGIN
--
  Nm_Debug.proc_start(g_package_name,'split_placement_array');
   FOR l_count IN 1..this_npa.placement_count
    LOOP
--
      l_current := this_npa.npa_placement_array(l_count);
--
      IF l_current.pl_measure = 0
       THEN
         l_measure_subtract := 0;
      END IF;
--
      IF   l_current.pl_ne_id = pi_ne_id
       AND pi_mp BETWEEN l_current.pl_start AND l_current.pl_end
       THEN
--
         IF l_current.pl_start != pi_mp
          THEN
            -- Only create this one if there is a length between the current start and the pi_mp
           add_element_to_pl_arr (pio_pl_arr => l_retval
                                 ,pi_ne_id   => l_current.pl_ne_id
                                 ,pi_start   => l_current.pl_start
                                 ,pi_end     => pi_mp
                                 ,pi_measure => l_current.pl_measure
                                 ,pi_mrg_mem => TRUE
                                 );
         END IF;
           add_element_to_pl_arr (pio_pl_arr => l_retval
                                 ,pi_ne_id   => l_current.pl_ne_id
                                 ,pi_start   => pi_mp
                                 ,pi_end     => l_current.pl_end
                                 ,pi_measure => 0
                                 ,pi_mrg_mem => FALSE
                                 );
         l_measure_subtract := l_current.pl_measure + (pi_mp-l_current.pl_start);
      ELSE
           add_element_to_pl_arr (pio_pl_arr => l_retval
                                 ,pi_ne_id   => l_current.pl_ne_id
                                 ,pi_start   => l_current.pl_start
                                 ,pi_end     => l_current.pl_end
                                 ,pi_measure => l_current.pl_measure - l_measure_subtract
                                 ,pi_mrg_mem => TRUE
                                 );
      END IF;
--
   END LOOP;
--
  Nm_Debug.proc_end(g_package_name,'split_placement_array');
   RETURN l_retval;
--
END split_placement_array;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE split_placement_array (this_npa    IN     nm_placement_array
                                ,pi_ne_id    IN     nm_members.nm_ne_id_of%TYPE
                                ,pi_mp       IN     nm_members.nm_begin_mp%TYPE
                                ,po_npa_pre     OUT nm_placement_array
                                ,po_npa_post    OUT nm_placement_array
                                ,pi_allow_zero_length_placement IN BOOLEAN DEFAULT TRUE
                                ) IS
--
   l_pl      nm_placement_array := initialise_placement_array;
--
   l_split_point_done BOOLEAN := FALSE;
--
   l_current nm_placement;
--
BEGIN
--
  Nm_Debug.proc_start(g_package_name,'split_placement_array');
   -- Initialise return arguments
   po_npa_pre  := initialise_placement_array;
   po_npa_post := initialise_placement_array;
--
-- Call the function to split the array into 2 bits
   l_pl := split_placement_array (this_npa, pi_ne_id, pi_mp);
--
   -- Then split the single placement array into 2
   FOR l_count IN 1..l_pl.placement_count
    LOOP
--
      l_current := l_pl.npa_placement_array(l_count);
--
      IF   l_current.pl_ne_id = pi_ne_id
       AND l_current.pl_start = pi_mp
       THEN
         l_split_point_done := TRUE;
      END IF;
--
      IF l_split_point_done
       THEN
         IF NOT pi_allow_zero_length_placement
          AND l_current.pl_start = l_current.pl_end
          THEN
            NULL;
         ELSE
           add_element_to_pl_arr (pio_pl_arr => po_npa_post
                                 ,pi_ne_id   => l_current.pl_ne_id
                                 ,pi_start   => l_current.pl_start
                                 ,pi_end     => l_current.pl_end
                                 ,pi_measure => l_current.pl_measure
                                 ,pi_mrg_mem => TRUE
                                 );
         END IF;
      ELSE
         IF NOT pi_allow_zero_length_placement
          AND l_current.pl_start = l_current.pl_end
          THEN
            NULL;
         ELSE
           add_element_to_pl_arr (pio_pl_arr => po_npa_pre
                                 ,pi_ne_id   => l_current.pl_ne_id
                                 ,pi_start   => l_current.pl_start
                                 ,pi_end     => l_current.pl_end
                                 ,pi_measure => l_current.pl_measure
                                 ,pi_mrg_mem => TRUE
                                 );
         END IF;
      END IF;
--
   END LOOP;
  Nm_Debug.proc_end(g_package_name,'split_placement_array');
--
END split_placement_array;
--
------------------------------------------------------------------------------------------------
--
FUNCTION check_exists_in_placement_arr (this_npa    IN     nm_placement_array
                                       ,pi_ne_id    IN     nm_members.nm_ne_id_of%TYPE
                                       ,pi_mp       IN     nm_members.nm_begin_mp%TYPE
                                       ) RETURN BOOLEAN IS
--
   l_retval  BOOLEAN := FALSE;
   l_current nm_placement;
--
BEGIN
--
  Nm_Debug.proc_start(g_package_name,'check_exists_in_placement_arr');
   FOR l_count IN 1..this_npa.placement_count
    LOOP
--
      l_current := this_npa.npa_placement_array(l_count);
--
      IF   l_current.pl_ne_id = pi_ne_id
       AND pi_mp BETWEEN l_current.pl_start AND l_current.pl_end
       THEN
         l_retval := TRUE;
         EXIT;
      END IF;
--
   END LOOP;
  Nm_Debug.proc_end(g_package_name,'check_exists_in_placement_arr');
--
   RETURN l_retval;
--
END check_exists_in_placement_arr;
--
------------------------------------------------------------------------------------------------
--
FUNCTION derive_ne_id_relation (pi_ne_id_1 IN nm_elements.ne_id%TYPE
                               ,pi_ne_id_2 IN nm_elements.ne_id%TYPE
                               ) RETURN VARCHAR2 IS
BEGIN
--
   RETURN derive_placement_arr_relation (Nm3pla.Get_Placement_From_Ne (pi_ne_id_1)
                                        ,Nm3pla.Get_Placement_From_Ne (pi_ne_id_2)
                                        );
--
END derive_ne_id_relation;
--
------------------------------------------------------------------------------------------------
--
FUNCTION derive_placement_arr_relation (pi_pl_1 IN nm_placement_array
                                       ,pi_pl_2 IN nm_placement_array
                                       ) RETURN VARCHAR2 IS

--
   l_relation              VARCHAR2(20);
--
   l_pl1_starts_within_pl2 BOOLEAN;
   l_pl1_ends_within_pl2   BOOLEAN;
   l_pl2_starts_within_pl1 BOOLEAN;
   l_pl2_ends_within_pl1   BOOLEAN;
--
   l_pl1_first             nm_placement;
   l_pl1_last              nm_placement;
   l_pl2_first             nm_placement;
   l_pl2_last              nm_placement;
--
   a_little_bit CONSTANT NUMBER := 0.0001;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'derive_placement_arr_relation');
--
   IF  pi_pl_1.is_empty
    OR pi_pl_2.is_empty
    THEN
      RETURN c_not_found;
   END IF;
--
   l_pl1_first := pi_pl_1.npa_placement_array(pi_pl_1.npa_placement_array.FIRST);
   l_pl1_last  := pi_pl_1.npa_placement_array(pi_pl_1.placement_count);
   l_pl2_first := pi_pl_2.npa_placement_array(pi_pl_2.npa_placement_array.FIRST);
   l_pl2_last  := pi_pl_2.npa_placement_array(pi_pl_2.placement_count);
--
   l_pl1_starts_within_pl2 := Nm3pla.check_exists_in_placement_arr
                               (this_npa => pi_pl_2
                               ,pi_ne_id => l_pl1_first.pl_ne_id
                               ,pi_mp    => l_pl1_first.pl_start + a_little_bit
                               );
--   IF l_pl1_starts_within_pl2
--    THEN
--      dbms_output.put_line('l_pl1_starts_within_pl2');
--   else
--      dbms_output.put_line('NOT l_pl1_starts_within_pl2');
--   end if;
--
   l_pl1_ends_within_pl2 := Nm3pla.check_exists_in_placement_arr
                               (this_npa => pi_pl_2
                               ,pi_ne_id => l_pl1_last.pl_ne_id
                               ,pi_mp    => l_pl1_last.pl_end - a_little_bit
                               );
--   IF l_pl1_ends_within_pl2
--    THEN
--      dbms_output.put_line('l_pl1_ends_within_pl2');
--   else
--      dbms_output.put_line('NOT l_pl1_ends_within_pl2');
--   end if;
--
   l_pl2_starts_within_pl1 := Nm3pla.check_exists_in_placement_arr
                               (this_npa => pi_pl_1
                               ,pi_ne_id => l_pl2_first.pl_ne_id
                               ,pi_mp    => l_pl2_first.pl_start + a_little_bit
                               );
--   IF l_pl2_starts_within_pl1
--    THEN
--      dbms_output.put_line('l_pl2_starts_within_pl1');
--   else
--      dbms_output.put_line('NOT l_pl2_starts_within_pl1');
--   end if;
--
   l_pl2_ends_within_pl1 := Nm3pla.check_exists_in_placement_arr
                               (this_npa => pi_pl_1
                               ,pi_ne_id => l_pl2_last.pl_ne_id
                               ,pi_mp    => l_pl2_last.pl_end - a_little_bit
                               );
--   IF l_pl2_ends_within_pl1
--    THEN
--      dbms_output.put_line('l_pl2_ends_within_pl1');
--   else
--      dbms_output.put_line('NOT l_pl2_ends_within_pl1');
--   end if;
--
   IF (    NOT l_pl1_starts_within_pl2
       AND NOT l_pl1_ends_within_pl2
       AND NOT l_pl2_starts_within_pl1
       AND NOT l_pl2_ends_within_pl1
       )
    THEN
      l_relation := c_none;
   ELSIF (l_pl1_starts_within_pl2 AND l_pl1_ends_within_pl2)
    THEN
      l_relation := c_internal;
   ELSIF (l_pl1_starts_within_pl2 AND l_pl2_ends_within_pl1)
    THEN
      l_relation := c_olap_end;
   ELSIF (l_pl2_starts_within_pl1 AND l_pl1_ends_within_pl2)
    THEN
      l_relation := c_olap_begin;
   ELSIF (l_pl2_starts_within_pl1 AND l_pl2_ends_within_pl1)
    THEN
      l_relation := c_olap_b_e;
   ELSIF  are_placements_connected (l_pl1_first,l_pl2_last)
    OR    are_placements_connected (l_pl2_first,l_pl1_last)
    THEN
      l_relation := c_connected;
   ELSE
      l_relation := c_unknown;
   END IF;
--
   Nm_Debug.proc_end(g_package_name,'derive_placement_arr_relation');
--
   RETURN l_relation;
--
END derive_placement_arr_relation;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_ne_intersection(ne_id1 nm_members.nm_ne_id_in%TYPE, ne_id2 nm_members.nm_ne_id_in%TYPE)

   RETURN nm_placement_array
AS
-- Create a nm_placement_array that contains the details of where the two passed inv_items intersect
--
-- item 33006 ne_id begin_mp end_mp
--            2     30       60
--            3      0       30
--            4      0       40
-- item 455508 ne_id begin_mp end_mp
--             2     40        60
--             3      0        30
--             4      0       210
-- result is
--            ne_id begin_mp end_mp
--            2     40       60
--            3      0       30
--            4      0       40

  TYPE tab_rec IS RECORD  (ne_id nm_members.nm_ne_id_of%TYPE,
                           begin_mp nm_members.nm_begin_mp%TYPE,
                           end_mp nm_members.nm_end_mp%TYPE);


  TYPE tab_type IS TABLE OF tab_rec INDEX BY BINARY_INTEGER;

  table1   tab_type;
  inter    tab_rec;
  inter_pl nm_placement_array := Nm3pla.initialise_placement_array;

  CURSOR c1(pne_id nm_members.nm_ne_id_in%TYPE) IS
     SELECT nm_ne_id_of, nm_begin_mp, nm_end_mp
     FROM nm_members
     WHERE nm_ne_id_in = ne_id1
     ORDER BY 1,2,3;

  CURSOR c2(p_ne_id_of nm_members.nm_ne_id_of%TYPE) IS
    SELECT nm_ne_id_of, nm_begin_mp, nm_end_mp
    FROM nm_members
    WHERE nm_ne_id_of = p_ne_id_of
      AND nm_ne_id_in = ne_id2;


  cnt INTEGER := 0;
BEGIN

  Nm_Debug.proc_start(g_package_name,'get_ne_intersection');
  -- get the sections covered by the 1st item
  cnt := 0;
  FOR c1rec IN c1(ne_id1) LOOP
      table1(cnt) := c1rec;
      cnt := cnt +1;
  END LOOP;
  cnt := cnt -1;

  FOR i IN 0..cnt LOOP
    -- get the sections covered by the 2nd item that are the covered by the 1st item
    FOR c2rec IN c2(table1(i).ne_id) LOOP
        inter.ne_id := table1(i).ne_id;
        -- decide which itemm starts 1st on the scetion
        IF table1(i).begin_mp >= c2rec.nm_begin_mp THEN
           inter.begin_mp := table1(i).begin_mp;
        ELSE
           inter.begin_mp := c2rec.nm_begin_mp;
        END IF;

        -- decide which item finishes 1st on the section
        IF table1(i).end_mp <= c2rec.nm_end_mp THEN
           inter.end_mp := table1(i).end_mp;
        ELSE
           inter.end_mp := c2rec.nm_end_mp;
        END IF;
        -- add the element to the placement array
           add_element_to_pl_arr (pio_pl_arr => inter_pl
                                 ,pi_ne_id   => inter.ne_id
                                 ,pi_start   => inter.begin_mp
                                 ,pi_end     => inter.end_mp
                                 ,pi_measure => 0
                                 ,pi_mrg_mem => TRUE
                                 );
    END LOOP;
  END LOOP;

  Nm_Debug.proc_end(g_package_name,'get_ne_intersection');
  RETURN inter_pl;

  EXCEPTION
   WHEN OTHERS THEN
     RETURN NULL;

END get_ne_intersection;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE dump_placement_array
                (p_pl_arr IN nm_placement_array
                ,p_level  IN NUMBER  DEFAULT Nm_Debug.c_default_level
                ) IS
BEGIN
--
  Nm_Debug.proc_start(g_package_name,'dump_placement_array');
   IF p_pl_arr.is_empty
    THEN
--
      Nm_Debug.DEBUG ('Placement array empty'
                     ,p_level
                   );
--
   ELSE
--
      FOR i IN 1..p_pl_arr.placement_count
       LOOP
         Nm_Debug.DEBUG ('Pos('||i||')'
                         ||'-'||p_pl_arr.npa_placement_array(i).pl_ne_id
                         ||'('||Nm3net.get_ne_unique(p_pl_arr.npa_placement_array(i).pl_ne_id)||')'
                         ||','||p_pl_arr.npa_placement_array(i).pl_start
                         ||','||p_pl_arr.npa_placement_array(i).pl_end
                         ||','||p_pl_arr.npa_placement_array(i).pl_measure
                        ,p_level
                        );
      END LOOP;
--
   END IF;
  Nm_Debug.proc_end(g_package_name,'dump_placement_array');
--
END dump_placement_array;
--
-----------------------------------------------------------------------------
--
FUNCTION count_pl_arr_connected_chunks
           (pi_pl_arr IN nm_placement_array) RETURN BINARY_INTEGER IS
--
   l_pl nm_placement_array;
--
   CURSOR cs_count IS
   SELECT COUNT(*)
    FROM  TABLE(CAST(l_pl.npa_placement_array AS nm_placement_array_type))
   WHERE  pl_measure = 0;
--
   l_retval BINARY_INTEGER;
--
BEGIN
--
  Nm_Debug.proc_start(g_package_name,'count_pl_arr_connected_chunks');
   l_pl := defrag_placement_array(pi_pl_arr);
--
   OPEN  cs_count;
   FETCH cs_count INTO l_retval;
   CLOSE cs_count;
--
  Nm_Debug.proc_end(g_package_name,'count_pl_arr_connected_chunks');
   RETURN l_retval;
--
END count_pl_arr_connected_chunks;
--
-----------------------------------------------------------------------------
--
FUNCTION count_pl_arr_distinct_subclass
           (pi_pl_arr IN nm_placement_array) RETURN BINARY_INTEGER IS
--
   TYPE tab_varchar IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
   l_tab_subclass tab_varchar;
--
   l_tab_found    tab_varchar;
   l_found        BOOLEAN;
--
   l_ne_id        NUMBER;
--
   CURSOR cs_subclass (c_ne_id NUMBER) IS
   SELECT ne_nt_type||'.'||ne_sub_class
    FROM  nm_elements
   WHERE  ne_id = c_ne_id;
--
BEGIN
--
  Nm_Debug.proc_start(g_package_name,'count_pl_arr_distinct_subclass');
   FOR l_count IN 1..pi_pl_arr.npa_placement_array.COUNT
    LOOP
      l_ne_id := pi_pl_arr.npa_placement_array(l_count).pl_ne_id;
      -- Have this IF so we only look once per NE_ID
      IF NOT l_tab_subclass.EXISTS(l_ne_id)
       THEN
         l_tab_subclass(l_ne_id) := NULL;
         OPEN  cs_subclass (l_ne_id);
         FETCH cs_subclass INTO l_tab_subclass(l_ne_id);
         CLOSE cs_subclass;
         l_found := FALSE;
         -- Now that we've found the subclass look to see if it's any
         --  different from any others we've already got
         FOR i IN 1..l_tab_found.COUNT
          LOOP
            IF l_tab_subclass(l_ne_id) = l_tab_found(i)
             THEN
               l_found := TRUE;
               EXIT;
            END IF;
         END LOOP;
         -- If we've never seen this one before then add it into
         --  the array of the ones we've got
         IF NOT l_found
          THEN
            l_tab_found(l_tab_found.COUNT+1) := l_tab_subclass(l_ne_id);
         END IF;
      END IF;
   END LOOP;
--
  Nm_Debug.proc_end(g_package_name,'count_pl_arr_distinct_subclass');
   RETURN l_tab_found.COUNT;
--
END count_pl_arr_distinct_subclass;

-----------------------------------------------------------------------------
--

FUNCTION get_placement_chunks ( p_pl IN nm_placement_array ) RETURN nm_placement_array IS
--
retval nm_placement_array := Nm3pla.initialise_placement_array;
l_pl   nm_placement := p_pl.npa_placement_array(1);
--
l_measure NUMBER;
l_ne_id   NUMBER;
l_start   NUMBER;
l_end     NUMBER;
--
BEGIN
--
  Nm_Debug.proc_start(g_package_name,'get_placement_chunks');
  retval.npa_placement_array(1) := l_pl;
--
  FOR irec IN 2..p_pl.placement_count LOOP
    IF p_pl.npa_placement_array( irec ).pl_measure = 0 THEN
           add_element_to_pl_arr (pio_pl_arr => retval
                                 ,pi_pl      => l_pl
                                 ,pi_mrg_mem => TRUE
                                 );
--      retval := retval.add_element(l_pl);

      l_pl := p_pl.npa_placement_array (irec);
           add_element_to_pl_arr (pio_pl_arr => retval
                                 ,pi_pl      => l_pl
                                 ,pi_mrg_mem => TRUE
                                 );
--      retval := retval.add_element(l_pl);

    ELSE

      l_pl := p_pl.npa_placement_array (irec);

    END IF;
  END LOOP;
--
           add_element_to_pl_arr (pio_pl_arr => retval
                                 ,pi_pl      => l_pl
                                 ,pi_mrg_mem => TRUE
                                 );
--  retval := retval.add_element(l_pl);
--
  Nm_Debug.proc_end(g_package_name,'get_placement_chunks');
  RETURN retval;
END get_placement_chunks;

-----------------------------------------------------------------------------
--

FUNCTION get_connected_placement ( pi_ne_id IN nm_elements.ne_id%TYPE )
      RETURN nm_placement_array IS

retval nm_placement_array := Nm3pla.initialise_placement_array;

-- get all the starting points of each chunk

CURSOR c1 ( c_ne_id nm_elements.ne_id%TYPE )IS
 SELECT s.ne_id ne_id, s.ne_sub_class sub_class,
        s.ne_no_start st_node, s.ne_no_end end_node, s.ne_length ne_length,
                m1.nm_cardinality CARDINALITY
 FROM nm_elements s, nm_members m1
 WHERE  s.ne_id = m1.nm_ne_id_of
 AND    m1.nm_ne_id_in = c_ne_id
 AND    NOT EXISTS ( SELECT 'x' FROM nm_elements c, nm_members m2
                    WHERE c.ne_id = m2.nm_ne_id_of
                    AND   m2.nm_ne_id_in = c_ne_id
                    AND   NVL(c.ne_sub_class,'%^&*') = NVL(s.ne_sub_class, '%^&*')
                    AND   c.ne_id != s.ne_id
                    AND c.ne_no_end = s.ne_no_start);

CURSOR c2 ( c_start_ne_id nm_elements.ne_id%TYPE, c_ne_id nm_elements.ne_id%TYPE )IS
  SELECT ne_id, ne_length, Nm3lrs.get_element_true( c_ne_id, ne_id), Nm3net.get_ne_unique( ne_id )
  FROM nm_elements
  CONNECT BY PRIOR get_next_element(c_ne_id, ne_id ) = ne_id
  START WITH ne_id = get_next_element( c_ne_id, c_start_ne_id);

l_pl   nm_placement;
l_sub_class nm_elements.ne_sub_class%TYPE;
l_measure NUMBER := 0;
BEGIN

  Nm_Debug.proc_start(g_package_name,'get_connected_placement');
  FOR irec IN c1( pi_ne_id ) LOOP
    l_pl := nm_placement( irec.ne_id, 0, irec.ne_length, 0 );
           add_element_to_pl_arr (pio_pl_arr => retval
                                 ,pi_pl      => l_pl
                                 ,pi_mrg_mem => TRUE
                                 );

    l_measure := irec.ne_length;

    FOR jrec IN c2( irec.ne_id,  pi_ne_id ) LOOP

      l_pl := nm_placement( jrec.ne_id, 0, jrec.ne_length, l_measure );

           add_element_to_pl_arr (pio_pl_arr => retval
                                 ,pi_pl      => l_pl
                                 ,pi_mrg_mem => TRUE
                                 );

      l_measure := l_measure + jrec.ne_length;

    END LOOP;
  END LOOP;

  Nm_Debug.proc_end(g_package_name,'get_connected_placement');
  RETURN retval;
END;

-----------------------------------------------------------------------------
--
FUNCTION get_next_element( pi_route_id IN NUMBER, pi_ne_id IN NUMBER ) RETURN NUMBER IS
CURSOR c1 (c_route_id NUMBER, c_ne_id NUMBER ) IS
  SELECT a.nnu_ne_id
  FROM  nm_node_usages a, nm_members, nm_node_usages b
  WHERE a.nnu_ne_id = nm_ne_id_of
  AND   a.nnu_no_node_id = Nm3net.get_start_node( nm_ne_id_of )
  AND   a.nnu_ne_id != c_ne_id
  AND   b.nnu_ne_id =  c_ne_id
  AND   b.nnu_no_node_id = a.nnu_no_node_id
  AND   nm_ne_id_in = c_route_id
  AND   Nm3net.get_sub_class(a.nnu_ne_id) = Nm3net.get_sub_class(b.nnu_ne_id);

l_ne_id NUMBER;

BEGIN
  Nm_Debug.proc_start(g_package_name,'get_next_element');
  OPEN c1 ( pi_route_id, pi_ne_id );
  FETCH c1 INTO l_ne_id;
  IF c1%NOTFOUND THEN
    l_ne_id := -1;
  END IF;

  Nm_Debug.proc_end(g_package_name,'get_next_element');
  RETURN l_ne_id;

END get_next_element;
--
-----------------------------------------------------------------------------
--
FUNCTION get_next_element2 (pi_route_id  IN NUMBER
                           ,pi_ne_id     IN NUMBER
                           ,pi_sub_class IN VARCHAR2
                           ) RETURN NUMBER IS
--
   CURSOR c1 (c_route_id  NUMBER
             ,c_ne_id     NUMBER
             ,c_sub_class VARCHAR2
             )  IS
   SELECT nnu1.nnu_ne_id
    FROM  nm_node_usages nnu1
         ,nm_members     nm1
         ,nm_elements    ne1
         ,nm_node_usages nnu2
         ,nm_members     nm2
         ,nm_elements    ne2
   WHERE  nnu1.nnu_ne_id                = nm1.nm_ne_id_of
    AND   nnu2.nnu_ne_id                = nm2.nm_ne_id_of
    AND   nnu1.nnu_ne_id               != c_ne_id
    AND   nnu2.nnu_ne_id                =  c_ne_id
    AND   nnu2.nnu_no_node_id           = nnu1.nnu_no_node_id
    AND   nm1.nm_ne_id_in               = c_route_id
    AND   nm2.nm_ne_id_in               = c_route_id
    AND   nm1.nm_ne_id_of               = ne1.ne_id
    AND   nm2.nm_ne_id_of               = ne2.ne_id
    AND   NVL(ne1.ne_sub_class,'$!$%') != c_sub_class
    AND   NVL(ne2.ne_sub_class,'$!$%') != c_sub_class
    AND   nnu2.nnu_node_type            = DECODE(nm2.nm_cardinality
                                                ,1,'E'
                                                ,-1,'S'
                                                )
    AND   nnu1.nnu_node_type            = DECODE(nm2.nm_cardinality*nm1.nm_cardinality
                                                ,1,DECODE(nnu2.nnu_node_type
                                                         ,'S','E'
                                                         ,'E','S'
                                                         )
                                                ,nnu2.nnu_node_type
                                                );
--
   l_ne_id NUMBER;
--
BEGIN
--
   OPEN  c1 ( pi_route_id, pi_ne_id, NVL( pi_sub_class, '1234'));
   FETCH c1 INTO l_ne_id;
   IF c1%NOTFOUND
    THEN
      l_ne_id := -1;
   END IF;
   CLOSE c1;
--
   RETURN l_ne_id;
--
END get_next_element2;
-----------------------------------------------------------------------------
FUNCTION get_connected_extent( pi_st_lref IN nm_lref,
                               pi_end_lref IN nm_lref,
                               pi_route  IN nm_elements.ne_id%TYPE,
                               pi_sub_class IN nm_elements.ne_sub_class%TYPE )
              RETURN nm_placement_array IS

-- Note that the supplied sub-class is an excluded sub-class

  e_no_connectivity EXCEPTION;

  CURSOR c1 IS
    SELECT * FROM 
    (SELECT CONNECT_BY_ISCYCLE connectby, ne_id, ne_length, Nm3net.get_cardinality( pi_route, ne_id) ne_cardinality
    FROM nm_elements
    WHERE NVL(ne_sub_class, '÷÷÷÷') != NVL(pi_sub_class,'÷$%^')
    CONNECT BY NOCYCLE PRIOR get_next_element2(pi_route, ne_id, pi_sub_class ) = ne_id
    AND NVL(ne_sub_class, '÷÷÷÷') != NVL(pi_sub_class,'÷$%^')
    START WITH ne_id = get_next_element2(pi_route, pi_st_lref.lr_ne_id, pi_sub_class )
    AND NVL(ne_sub_class, '÷÷÷÷') != NVL(pi_sub_class,'÷$%^'))
    WHERE connectby = 0;

  l_st_true  NUMBER := Nm3lrs.get_element_true( pi_route, pi_st_lref.lr_ne_id );
  l_end_true NUMBER := Nm3lrs.get_element_true( pi_route, pi_end_lref.lr_ne_id );

  l_st_seg    NUMBER := Nm3lrs.get_element_seg_no( pi_route, pi_st_lref.lr_ne_id );
  l_end_seg   NUMBER := Nm3lrs.get_element_seg_no( pi_route, pi_end_lref.lr_ne_id );

  retval     nm_placement_array := Nm3pla.initialise_placement_array;
  l_pl       nm_placement;
  l_measure  NUMBER := 0;

  l_st_cardinality NUMBER := Nm3net.get_cardinality( pi_route, pi_st_lref.lr_ne_id );

  l_start_offset NUMBER;
  l_end_offset   NUMBER;

BEGIN

  Nm_Debug.proc_start(g_package_name,'get_connected_extent');

  IF l_st_seg = l_end_seg
  THEN
    IF (pi_st_lref.lr_ne_id = pi_end_lref.lr_ne_id
        AND ((l_st_cardinality = 1
              AND pi_st_lref.lr_offset > pi_end_lref.lr_offset)
             OR
              (l_st_cardinality = -1
               AND pi_end_lref.lr_offset > pi_st_lref.lr_offset)))
       OR l_st_true > l_end_true
    THEN
      RAISE_APPLICATION_ERROR ( -20041, 'Start position is further along the route than the end');
    END IF;
  ELSE
    --
    --  Different segment numbers, check true distance at start/end of segments
    --
--    nm_debug.debug('NOT Same seg');
    IF Nm3lrs.min_seg_true( pi_route, l_end_seg ) <=
       Nm3lrs.max_seg_true( pi_route, l_st_seg )
    THEN
--      nm_debug.debug( 'No connectivity - segs are '||TO_CHAR( nm3lrs.min_seg_true( pi_route, l_end_seg ) )||
--                      '<='||TO_CHAR(nm3lrs.max_seg_true( pi_route, l_st_seg )));

      RAISE e_no_connectivity;
    END IF;
  END IF;

  --If no sub-class supplied, then check the sub-class of elements between the two
  --values and if more than one then force a sub-class.

  IF pi_sub_class IS NULL
    AND NOT Nm3lrs.unique_sub_class( pi_route, l_st_true, l_end_true )
  THEN
    RAISE_APPLICATION_ERROR ( -20043, 'No unique sub-class supplied ');
  END IF;

  IF l_st_cardinality = 1 THEN

    l_pl := nm_placement( pi_st_lref.lr_ne_id, pi_st_lref.lr_offset,
                          Nm3net.get_datum_element_length( pi_st_lref.lr_ne_id ), 0);
  ELSE

    l_pl := nm_placement( pi_st_lref.lr_ne_id, 0, pi_st_lref.lr_offset, 0);

  END IF;

--  nm_debug.debug('Init pl ');

  IF pi_st_lref.lr_ne_id = pi_end_lref.lr_ne_id
  THEN
    IF l_st_cardinality = -1
      AND pi_st_lref.lr_offset > pi_end_lref.lr_offset
    THEN
      l_start_offset := pi_end_lref.lr_offset;
      l_end_offset   := pi_st_lref.lr_offset;
    ELSE
      l_start_offset := pi_st_lref.lr_offset;
      l_end_offset   := pi_end_lref.lr_offset;
    END IF;

    l_pl := nm_placement(pi_st_lref.lr_ne_id, l_start_offset, l_end_offset, 0);

           add_element_to_pl_arr (pio_pl_arr => retval
                                 ,pi_pl      => l_pl
                                 ,pi_mrg_mem => TRUE
                                 );

  ELSE
           add_element_to_pl_arr (pio_pl_arr => retval
                                 ,pi_pl      => l_pl
                                 ,pi_mrg_mem => TRUE
                                 );
    l_measure := Nm3net.get_datum_element_length( pi_st_lref.lr_ne_id ) - pi_st_lref.lr_offset;

--    nm3pla.dump_placement_array(retval);

    FOR irec IN c1
    LOOP

      --   loop over all elements between the two true values, restricted by the optional sub-class,
      --   insert all the sub-elements into the extent tables

      --   within the loop, if any element has a true distance which is greater than the end then fail.

      l_pl := nm_placement( irec.ne_id, 0, irec.ne_length, l_measure);

      IF irec.ne_id = pi_end_lref.lr_ne_id
      THEN
        --      end of loop
        IF irec.ne_cardinality = 1 THEN
          l_pl := nm_placement( irec.ne_id, 0, pi_end_lref.lr_offset, l_measure);

           add_element_to_pl_arr (pio_pl_arr => retval
                                 ,pi_pl      => l_pl
                                 ,pi_mrg_mem => TRUE
                                 );
        ELSE

          l_pl := nm_placement( irec.ne_id, pi_end_lref.lr_offset, irec.ne_length, l_measure);

           add_element_to_pl_arr (pio_pl_arr => retval
                                 ,pi_pl      => l_pl
                                 ,pi_mrg_mem => TRUE
                                 );
        END IF;

        EXIT;
      ELSE
        l_measure := l_measure + irec.ne_length;
      END IF;

           add_element_to_pl_arr (pio_pl_arr => retval
                                 ,pi_pl      => l_pl
                                 ,pi_mrg_mem => TRUE
                                 );
    END LOOP;
  END IF;

  IF retval.get_entry(retval.placement_count).pl_ne_id <> pi_end_lref.get_ne_id
  THEN
    RAISE e_no_connectivity;
  END IF;

  Nm_Debug.proc_start(g_package_name,'get_connected_extent');

  RETURN retval;

EXCEPTION
  WHEN e_no_connectivity
  THEN
    RAISE_APPLICATION_ERROR ( -20042, 'Cannot establish connectivity between the start and end');

END get_connected_extent;
--
--------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_point_route_offsets(pi_ne_id    IN nm_inv_items.iit_ne_id%TYPE
                                ,pi_route_id IN nm_members.nm_ne_id_in%TYPE
                                ,pi_obj_type IN nm_members.nm_obj_type%TYPE
                                ) RETURN nm_placement_array IS
--
   CURSOR cs_mem (c_ne_id_in IN nm_inv_items.iit_ne_id%TYPE) IS
   SELECT nm_r.nm_ne_id_in
         ,nm_i.nm_ne_id_of
         ,nm_i.nm_begin_mp
         ,ngt.ngt_group_type
    FROM  nm_members     nm_i
         ,nm_members     nm_r
         ,nm_group_types ngt
   WHERE  nm_i.nm_ne_id_in    = c_ne_id_in
    AND   nm_i.nm_ne_id_of    = nm_r.nm_ne_id_of
    AND   nm_r.nm_type        = 'G'
    AND   nm_r.nm_obj_type    = ngt.ngt_group_type
    AND   ngt.ngt_linear_flag = 'Y'
    AND  (nm_i.nm_begin_mp  BETWEEN nm_r.nm_begin_mp AND nm_r.nm_end_mp
          OR nm_i.nm_end_mp BETWEEN nm_r.nm_begin_mp AND nm_r.nm_end_mp
         )
   ORDER BY nm_r.nm_obj_type
           ,nm_r.nm_ne_id_in
           ,nm_r.nm_seq_no;
--
   l_rte_offset NUMBER;
--
   l_retval nm_placement_array := Nm3pla.initialise_placement_array;
--
   l_tab_ne_id_in Nm3type.tab_number;
   l_tab_ne_id_of Nm3type.tab_number;
   l_tab_begin_mp Nm3type.tab_number;
   l_tab_obj_type Nm3type.tab_varchar4;
--
   l_add_element  BOOLEAN;
--
BEGIN
--
   OPEN  cs_mem (pi_ne_id);
   FETCH cs_mem
    BULK COLLECT
    INTO l_tab_ne_id_in
        ,l_tab_ne_id_of
        ,l_tab_begin_mp
        ,l_tab_obj_type;
   CLOSE cs_mem;
--
   FOR i IN 1..l_tab_ne_id_in.COUNT
    LOOP
      --
      IF    pi_route_id IS NULL
       AND  pi_obj_type IS NULL
       THEN
         -- no obj type or specific route specified then add it
         l_add_element := TRUE;
      ELSIF pi_route_id IS NOT NULL
       AND  pi_route_id = l_tab_ne_id_in(i)
       THEN
         -- this is the correct route as specified
         l_add_element := TRUE;
      ELSIF pi_obj_type IS NOT NULL
       AND  pi_obj_type = l_tab_obj_type(i)
       THEN
         -- this is the correct obj_type
         l_add_element := TRUE;
      ELSE
         -- there is a route or a group type specified and this one doesn't fit the bill
         l_add_element := FALSE;
      END IF;
      --
      IF l_add_element
       THEN
         l_rte_offset := Nm3lrs.get_set_offset(p_ne_parent_id => l_tab_ne_id_in(i)
                                              ,p_ne_child_id  => l_tab_ne_id_of(i)
                                              ,p_offset       => l_tab_begin_mp(i)
                                              );
           add_element_to_pl_arr (pio_pl_arr => l_retval
                                 ,pi_ne_id   => l_tab_ne_id_in(i)
                                 ,pi_start   => l_rte_offset
                                 ,pi_end     => l_rte_offset
                                 ,pi_measure => 0
                                 ,pi_mrg_mem => FALSE
                                 );
      END IF;
      --
   END LOOP;

  RETURN l_retval;
END;
--
--------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_connected_chunks_internal(pi_iof_tab    IN Nm3type.tab_number
                                      ,pi_ibegin_tab IN Nm3type.tab_number
                                      ,pi_iend_tab   IN Nm3type.tab_number
                                      ,pi_rin_tab    IN Nm3type.tab_number
                                      --,pi_rseq_tab   IN nm3type.tab_number
                                      ,pi_rdir_tab   IN Nm3type.tab_number
                                      --,pi_rbegin_tab IN nm3type.tab_number
                                      --,pi_rend_tab   IN nm3type.tab_number
                                      ) RETURN nm_placement_array IS

--  l_start_id NUMBER;
  l_begin_mp NUMBER;
  l_end_mp   NUMBER;

  l_route_id    NUMBER;
  l_prior_ne    NUMBER;
  l_prior_begin NUMBER;
  l_prior_end   NUMBER;
  l_prior_rdir  NUMBER;
  l_measure     NUMBER := 0;

  l_r_begin    NUMBER;
  l_r_end      NUMBER;

  rvrs BOOLEAN;
  rvrsi        INTEGER;  

  l_iit_rec nm_inv_items%ROWTYPE;

  retval nm_placement_array := Nm3pla.initialise_placement_array;
  
  lc integer := 0;

BEGIN
--nm_debug.debug_on;
--  nm_debug.debug('Internal cnct - count = '||pi_iof_tab.COUNT);
  FOR l_i IN 1..pi_iof_tab.COUNT
  LOOP
    rvrs := (Nm3net.is_gty_reversible( Nm3net.get_gty_type(pi_rin_tab(l_i))) = 'Y');
    if rvrs then
      rvrsi := 1;
    else
      rvrsi := 0;
    end if;      
  
    lc := lc + 1;
    
--    nm_debug.debug( 'row '||l_i||','||pi_iof_tab(l_i)||','||pi_rdir_tab(l_i)||','||pi_rin_tab(l_i)||','||pi_ibegin_tab(l_i)||','||pi_iend_tab(l_i));

    IF l_i = 1
    THEN
      l_begin_mp := pi_ibegin_tab(l_i);
      l_end_mp   := pi_iend_tab(l_i);
      
      if pi_rdir_tab(l_i) = 1 then
         l_r_begin := Nm3lrs.get_set_offset(pi_rin_tab(l_i), pi_iof_tab(l_i), pi_ibegin_tab(l_i));
         l_r_end   := Nm3lrs.get_set_offset(pi_rin_tab(l_i), pi_iof_tab(l_i), pi_iend_tab(l_i));
      else
          l_r_begin := Nm3lrs.get_set_offset(pi_rin_tab(l_i), pi_iof_tab(l_i), pi_iend_tab(l_i));
          l_r_end   := Nm3lrs.get_set_offset(pi_rin_tab(l_i), pi_iof_tab(l_i), pi_ibegin_tab(l_i));
      end if;
    
    ELSE

--      nm_debug.debug('next');
      
      lc := lc + 1;

      IF pi_rin_tab(l_i) = l_route_id
      THEN
--        nm_debug.debug('same route, continue checking element connectivity');
        IF pi_iof_tab(l_i) = l_prior_ne
        THEN
          IF ( pi_ibegin_tab(l_i) = l_end_mp and pi_rdir_tab(l_i) = 1) OR
             ( pi_iend_tab(l_i) = l_begin_mp and pi_rdir_tab(l_i) = -1)
          THEN
--              nm_debug.debug('Same element and connected');
              l_begin_mp := least(l_begin_mp, pi_ibegin_tab(l_i)); 
              l_end_mp   := greatest( l_end_mp, pi_iend_tab(l_i));

--              nm_debug.debug( l_i||' saved '||l_begin_mp||','||l_end_mp);
          ELSE

--              nm_debug.debug('Its the same element and there is a break between the end of last, start of this');

              if l_prior_rdir = 1 then
                 l_r_begin := Nm3lrs.get_set_offset(l_route_id, l_prior_ne, l_begin_mp);
                 l_r_end   := Nm3lrs.get_set_offset(l_route_id, l_prior_ne, l_end_mp);
              else
                  l_r_begin := Nm3lrs.get_set_offset(l_route_id, l_prior_ne, l_end_mp);
                  l_r_end   := Nm3lrs.get_set_offset(l_route_id, l_prior_ne, l_begin_mp);
              end if;

              nm3pla.add_element_to_pl_arr (pio_pl_arr => retval
                                     ,pi_ne_id   => l_route_id
                                     ,pi_start   => l_r_begin
                                     ,pi_end     => l_r_end
                                     ,pi_measure => 0
                                     ,pi_mrg_mem => FALSE
                                     );

              l_begin_mp := pi_ibegin_tab(l_i); 
              l_end_mp   := pi_iend_tab(l_i);

           END IF;

--           nm_debug.debug('Set prior '||l_prior_ne||','||','||l_prior_begin||','||l_prior_end );
--           nm_debug.debug( l_i||' saved '||l_begin_mp||','||l_end_mp);
--           nm_debug.debug( l_i||' route '||l_r_begin||','||l_r_end);

        ELSE
--        it is a different element in the same route, check its connected
--
--          nm_debug.debug( 'Different element in same route');

          if partial_chunk_connectivity( rvrsi, 
                   l_prior_ne, 
                   TO_NUMBER(pi_iof_tab(l_i)),
                   l_prior_rdir,
                   pi_rdir_tab(l_i),
                   l_prior_begin,
                   l_prior_end,
                   TO_NUMBER(pi_ibegin_tab(l_i)),
                   TO_NUMBER(pi_iend_tab(l_i))) = 1 then


  --          nm_debug.debug( 'Connected');
  --          nm_debug.debug( ' - begin '||TO_CHAR( l_begin_mp )||
  --                                     ' end   '||TO_CHAR( l_end_mp )||
  --                                     ' of    '||TO_CHAR( l_prior_ne ));
                                       
            l_begin_mp := pi_ibegin_tab(l_i); 
            l_end_mp   := pi_iend_tab(l_i);                                       

            if l_prior_rdir = 1 then
               l_r_end   := Nm3lrs.get_set_offset(l_route_id, pi_iof_tab(l_i), l_end_mp);
            else
                l_r_end   := Nm3lrs.get_set_offset(l_route_id, pi_iof_tab(l_i), l_begin_mp);
            end if;


          ELSE
--            nm_debug.debug('disc');
--          discontinuity is found so create a new


            nm3pla.add_element_to_pl_arr (pio_pl_arr => retval
                                 ,pi_ne_id   => l_route_id
                                 ,pi_start   => l_r_begin
                                 ,pi_end     => l_r_end
                                 ,pi_measure => 0
                                 ,pi_mrg_mem => FALSE
                                 );
                                 
            l_begin_mp := pi_ibegin_tab(l_i); 
            l_end_mp   := pi_iend_tab(l_i);

            if l_prior_rdir = 1 then
               l_r_begin := Nm3lrs.get_set_offset(l_route_id, pi_iof_tab(l_i), l_begin_mp);
               l_r_end   := Nm3lrs.get_set_offset(l_route_id, pi_iof_tab(l_i), l_end_mp);
            else
                l_r_begin := Nm3lrs.get_set_offset(l_route_id, pi_iof_tab(l_i), l_end_mp);
                l_r_end   := Nm3lrs.get_set_offset(l_route_id, pi_iof_tab(l_i), l_begin_mp);
            end if;

--            nm_debug.debug( l_i||' saved '||l_begin_mp||','||l_end_mp);
--            nm_debug.debug( l_i||' route '||l_r_begin||','||l_r_end);

          END IF;
        END IF;
      ELSE
--          nm_debug.debug('different route, assume a discontinuity');

        if l_prior_rdir = 1 then
--         l_r_begin := Nm3lrs.get_set_offset(l_route_id, l_prior_ne, l_begin_mp);
           l_r_end   := Nm3lrs.get_set_offset(l_route_id, l_prior_ne, l_end_mp);
        else
--          l_r_begin := Nm3lrs.get_set_offset(l_route_id, l_prior_ne, l_end_mp);
            l_r_end   := Nm3lrs.get_set_offset(l_route_id, l_prior_ne, l_begin_mp);
        end if;

        nm3pla.add_element_to_pl_arr (pio_pl_arr => retval
                                 ,pi_ne_id   => l_route_id
                                 ,pi_start   => l_r_begin
                                 ,pi_end     => l_r_end
                                 ,pi_measure => 0
                                 ,pi_mrg_mem => FALSE
                                 );
        l_begin_mp := pi_ibegin_tab(l_i); 
        l_end_mp   := pi_iend_tab(l_i);

      END IF;
    END IF;
    
    l_prior_ne    := pi_iof_tab(l_i);
    l_route_id    := pi_rin_tab(l_i);
--    l_start_id    := pi_iof_tab(l_i);
    l_prior_begin := pi_ibegin_tab(l_i);
    l_prior_end   := pi_iend_tab(l_i);
    l_prior_rdir  := pi_rdir_tab(l_i);

--    nm_debug.debug('end of loop set prior '||l_prior_ne||','||l_prior_begin||','||l_prior_end );
--    nm_debug.debug( l_i||' saved '||l_begin_mp||','||l_end_mp);
--    nm_debug.debug( l_i||' route '||l_r_begin||','||l_r_end);

  END LOOP;
--nm_debug.debug('end of loop');
  --at the end of the loop, we may need to add another row in the return
  IF l_prior_ne IS NOT NULL 
  THEN
  
    if lc > 1
    then
      if l_prior_rdir = 1 then
  --    l_r_begin := nvl(l_r_begin, Nm3lrs.get_set_offset(l_route_id, l_prior_ne, l_begin_mp));
        l_r_end   := Nm3lrs.get_set_offset(l_route_id, l_prior_ne, l_end_mp);
      else
--        l_r_begin := nvl(l_r_begin, Nm3lrs.get_set_offset(l_route_id, l_prior_ne, l_end_mp));
        l_r_end   := Nm3lrs.get_set_offset(l_route_id, l_prior_ne, l_begin_mp);
      end if;
    end if;

--    nm_debug.debug( 'outside loop '||' saved '||l_begin_mp||','||l_end_mp);
--    nm_debug.debug( ' route '||l_r_begin||','||l_r_end);
    nm3pla.add_element_to_pl_arr (pio_pl_arr => retval
                                 ,pi_ne_id   => l_route_id
                                 ,pi_start   => l_r_begin
                                 ,pi_end     => l_r_end
                                 ,pi_measure => 0
                                 ,pi_mrg_mem => FALSE
                                 );
  END IF;

  RETURN retval;

END get_connected_chunks_internal;
--
--------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_connected_chunks(p_ne_id IN nm_elements.ne_id%TYPE
                             ,p_route_id IN nm_members.nm_ne_id_in%TYPE
                             ,p_obj_type IN nm_members.nm_obj_type%TYPE
                             ) RETURN nm_placement_array IS

  l_iit_rec nm_inv_items%ROWTYPE;

  l_iof_tab    Nm3type.tab_number;
  l_ibegin_tab Nm3type.tab_number;
  l_iend_tab   Nm3type.tab_number;
  l_rin_tab    Nm3type.tab_number;
  l_rdir_tab   Nm3type.tab_number;

  l_retval nm_placement_array;

BEGIN

--nm_debug.debug_on;
--nm_debug.debug('Chunks1');
  --determine if ne_id is a point inv item
  l_iit_rec := Nm3inv.get_inv_item_all(pi_ne_id => p_ne_id);
  IF l_iit_rec.iit_ne_id IS NOT NULL
    AND Nm3inv.get_nit_pnt_or_cont(p_type => l_iit_rec.iit_inv_type) = 'P'
  THEN
    ----------------
    --point inv item
    ----------------
    l_retval := get_point_route_offsets(pi_ne_id    => p_ne_id
                                       ,pi_route_id => p_route_id
                                       ,pi_obj_type => p_obj_type);
  ELSE
    -----------------
    --continuous item
    -----------------
    SELECT
      i.nm_ne_id_of                                     iof,
      GREATEST(i.nm_begin_mp, r.nm_begin_mp)            ibegin,
      LEAST(i.nm_end_mp, NVL(r.nm_end_mp, i.nm_end_mp)) iend,
      r.nm_ne_id_in                                     rin,
      --r.nm_seq_no                                       rseq,
      r.nm_cardinality                                  rdir
      --r.nm_begin_mp                                     rbegin,
      --r.nm_end_mp                                       rend
    BULK COLLECT INTO
      l_iof_tab,
      l_ibegin_tab,
      l_iend_tab,
      l_rin_tab,
      l_rdir_tab
    FROM
      nm_members     i,
      nm_members     r,
      nm_group_types
    WHERE i.nm_ne_id_in = p_ne_id
    AND   r.nm_ne_id_in = NVL(p_route_id, r.nm_ne_id_in)
    AND   r.nm_obj_type = NVL(p_obj_type, r.nm_obj_type)
    AND   r.nm_obj_type = ngt_group_type
    AND   ngt_linear_flag = 'Y'
    AND   r.nm_ne_id_of = i.nm_ne_id_of
    AND   r.nm_type = 'G'
    AND ((i.nm_begin_mp < NVL(r.nm_end_mp, i.nm_end_mp)
      AND i.nm_end_mp   > r.nm_begin_mp) OR
        ((i.nm_begin_mp <= NVL(r.nm_end_mp, i.nm_end_mp)
      AND i.nm_end_mp   >= r.nm_begin_mp) AND i.nm_end_mp = i.nm_begin_mp))
    ORDER BY
      r.nm_obj_type,
      r.nm_ne_id_in,
      r.nm_seq_no,  i.nm_begin_mp * r.nm_cardinality;

--nm_debug.debug_on;
    l_retval := get_connected_chunks_internal(pi_iof_tab    => l_iof_tab
                                             ,pi_ibegin_tab => l_ibegin_tab
                                             ,pi_iend_tab   => l_iend_tab
                                             ,pi_rin_tab    => l_rin_tab
                                             ,pi_rdir_tab   => l_rdir_tab);
  END IF;

  RETURN l_retval;

END get_connected_chunks;
--
--------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_connected_chunks (pi_ne_id   IN nm_elements.ne_id%TYPE
                              ,pi_obj_type IN nm_members.nm_obj_type%TYPE
                              ) RETURN nm_placement_array IS
--
BEGIN
  Nm_Debug.proc_start(g_package_name,'get_connected_chunks');
--
--nm_debug.debug_on;
--nm_debug.debug('Chunks2');
  Nm_Debug.proc_end(g_package_name,'get_connected_chunks');
  RETURN get_connected_chunks(p_ne_id => pi_ne_id,
                              p_route_id => NULL,
                              p_obj_type => pi_obj_type );

--
END get_connected_chunks;
--
--------------------------------------------------------------------------------------------------------------------                              ) RETURN nm_placement_array IS
--
FUNCTION get_connected_chunks (pi_ne_id    IN nm_elements.ne_id%TYPE
                              ,pi_route_id IN nm_members.nm_ne_id_in%TYPE
                              ) RETURN nm_placement_array IS
--
BEGIN
  Nm_Debug.proc_start(g_package_name,'get_connected_chunks');
  Nm_Debug.proc_end(g_package_name,'get_connected_chunks');

  RETURN get_connected_chunks(p_ne_id => pi_ne_id,
                              p_route_id => pi_route_id,
                              p_obj_type => NULL );
--
END get_connected_chunks;
--
--------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_connected_chunks (pi_ne_id   IN nm_elements.ne_id%TYPE
                              ) RETURN nm_placement_array IS
--
BEGIN
  Nm_Debug.proc_start(g_package_name,'get_connected_chunks');
--
  Nm_Debug.proc_end(g_package_name,'get_connected_chunks');

  RETURN get_connected_chunks(p_ne_id => pi_ne_id,
                              p_route_id => NULL,
                              p_obj_type => NULL );
--
END get_connected_chunks;
--
--------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_connected_chunks(p_nte_job_id IN nm_nw_temp_extents.nte_job_id%TYPE
                             ,p_route_id   IN nm_members.nm_ne_id_in%TYPE
                             ,p_obj_type   IN nm_members.nm_obj_type%TYPE
                             ) RETURN nm_placement_array IS

  l_iof_tab    Nm3type.tab_number;
  l_ibegin_tab Nm3type.tab_number;
  l_iend_tab   Nm3type.tab_number;
  l_rin_tab    Nm3type.tab_number;
  l_rdir_tab   Nm3type.tab_number;

  l_retval nm_placement_array;

BEGIN

  SELECT /*+ RULE */
    i.nte_ne_id_of                                      iof,
    GREATEST(i.nte_begin_mp, r.nm_begin_mp)             ibegin,
    LEAST(i.nte_end_mp, NVL(r.nm_end_mp, i.nte_end_mp)) iend,
    r.nm_ne_id_in                                       rin,
    --r.nm_seq_no                                         rseq,
    r.nm_cardinality                                    rdir
    --r.nm_begin_mp                                       rbegin,
    --r.nm_end_mp                                         rend
  BULK COLLECT INTO
    l_iof_tab,
    l_ibegin_tab,
    l_iend_tab,
    l_rin_tab,
    l_rdir_tab
  FROM
    nm_nw_temp_extents i,
    nm_members         r,
    nm_group_types
  WHERE i.nte_job_id = p_nte_job_id
  AND   r.nm_ne_id_in = NVL(p_route_id, r.nm_ne_id_in)
  AND   r.nm_obj_type = NVL(p_obj_type, r.nm_obj_type)
  AND   r.nm_obj_type = ngt_group_type
  AND   ngt_linear_flag = 'Y'
  AND   r.nm_ne_id_of = i.nte_ne_id_of
  AND   r.nm_type = 'G'
  AND ((i.nte_begin_mp < NVL(r.nm_end_mp, i.nte_end_mp)
    AND i.nte_end_mp   > r.nm_begin_mp) OR
      ((i.nte_begin_mp <= NVL(r.nm_end_mp, i.nte_end_mp)
    AND i.nte_end_mp   >= r.nm_begin_mp) AND i.nte_end_mp = i.nte_begin_mp))
  ORDER BY
    r.nm_obj_type,
    r.nm_ne_id_in,
    r.nm_seq_no,
	i.nte_begin_mp;

  l_retval := get_connected_chunks_internal(pi_iof_tab    => l_iof_tab
                                           ,pi_ibegin_tab => l_ibegin_tab
                                           ,pi_iend_tab   => l_iend_tab
                                           ,pi_rin_tab    => l_rin_tab
                                           ,pi_rdir_tab   => l_rdir_tab);

  RETURN l_retval;

END get_connected_chunks;
--
--------------------------------------------------------------------------------------------------------------------
--
FUNCTION local_connected_chunks RETURN nm_placement_array IS
--
   l_start_id      NUMBER;
   l_start_mp      NUMBER;
   l_begin_mp      NUMBER;
   l_end_mp        NUMBER;
--
   l_route_id      NUMBER;
   l_prior_ne      NUMBER;
   l_prior_ele_len NUMBER;
--
   retval nm_placement_array := Nm3pla.initialise_placement_array;
--
   l_been_in_loop BOOLEAN := FALSE;
--
   irec rec_conn_chunk;
--
   l_node_id       nm_node_usages.nnu_no_node_id%TYPE;

   rvrs            BOOLEAN;
--
   PROCEDURE throw_change IS
   BEGIN
           add_element_to_pl_arr (pio_pl_arr => retval
                                 ,pi_ne_id   => l_route_id
                                 ,pi_start   => Nm3lrs.get_set_offset( l_route_id, l_start_id, l_start_mp )
                                 ,pi_end     => Nm3lrs.get_set_offset( l_route_id, l_prior_ne, l_end_mp )
                                 ,pi_measure => 0
                                 ,pi_mrg_mem => FALSE
                                 );
--
      l_prior_ne      := irec.iof;
      l_route_id      := irec.rin;
      l_begin_mp      := irec.ibegin;
      l_end_mp        := irec.iend;
      l_start_id      := irec.iof;
      l_start_mp      := irec.ibegin;
      l_prior_ele_len := irec.ne_length;
   END throw_change;
--
BEGIN
  Nm_Debug.proc_start(g_package_name,'local_connected_chunks');
--
   FOR i IN 1..g_conn_chunk.COUNT
    LOOP
--
      irec := g_conn_chunk(i);
      rvrs := (Nm3net.is_gty_reversible( Nm3net.get_gty_type( irec.rin )) = 'Y');

--
--      nm_debug.debug('## '||irec.iof||':'||irec.ibegin||'->'||irec.iend||':'||irec.rin||':'||irec.rseq);
--
      IF NOT l_been_in_loop
       THEN
--
         l_prior_ne      := irec.iof;
         l_route_id      := irec.rin;
         l_begin_mp      := irec.ibegin;
         l_end_mp        := irec.iend;
         l_start_id      := irec.iof;
         l_start_mp      := irec.ibegin;
         l_prior_ele_len := irec.ne_length;
--
         l_been_in_loop := TRUE;
--         nm_debug.debug('First time in');
--
      ELSE
--
         IF irec.rin = l_route_id
          THEN
--            nm_debug.debug('Same route');
--
--          same route, continue checking element connectivity
--
            IF irec.iof = l_prior_ne AND irec.ibegin != l_end_mp
             THEN
--
--            nm_debug.debug('Its the same element and there a break between the end of last, start of this');
--             Its the same element and there a break between the end of last, start of this
--
               throw_change;
--
            ELSE
--
               l_node_id := Nm3net.get_element_shared_node( l_prior_ne, irec.iof );
--
--             problem here - no cardinality but need to test connectivity - this
--             routine is only of use to MRWA
--
               IF   l_end_mp = l_prior_ele_len
                AND l_node_id IS NOT NULL
                THEN
                  -- If the elements are connected and it went ot the end of the first element
--            nm_debug.debug('no need to include this just update the prior and go on to next record');
 --               no need to include this just update the prior and go on to next record
--
--                Throw a change if this node is a POE, otherwise just carry on
--
                  IF Nm3net.is_node_poe(l_route_id,l_node_id)
                   THEN
                     throw_change;
                  ELSE
                     l_prior_ne      := irec.iof;
                     l_end_mp        := irec.iend;
                     l_prior_ele_len := irec.ne_length;
                  END IF;
               ELSE
--            nm_debug.debug('discontinuity is found so create a new');
 --               discontinuity is found so create a new
                  throw_change;
--
               END IF;
            END IF;
         ELSE
--            nm_debug.debug('different route, assume a discontinuity');
--       different route, assume a discontinuity
            throw_change;
--
         END IF;
      END IF;
   END LOOP;
--
-- at the end of the loop, we may need to add another row in the return
--
--   nm_debug.debug('at the end of the loop, we may need to add another row in the return');
   IF l_been_in_loop
    THEN
      throw_change;
   END IF;
--
   g_conn_chunk.DELETE;
--
  Nm_Debug.proc_end(g_package_name,'local_connected_chunks');
   RETURN retval;
--
END local_connected_chunks;
--
-----------------------------------------------------------------------------
--
FUNCTION are_placements_connected (p_pl_1 nm_placement
                                  ,p_pl_2 nm_placement
                                  ) RETURN BOOLEAN IS

l_retval BOOLEAN;

BEGIN

   l_retval := partial_chunk_connectivity ( TRUE,
	                                        p_pl_1.pl_ne_id, p_pl_2.pl_ne_id,
	                                        p_pl_1.pl_start, p_pl_1.pl_end,
	                                        p_pl_2.pl_start, p_pl_2.pl_end );
   RETURN l_retval;
--
END are_placements_connected;
--

/*

-------------------------------------------
-- commented by RAC. The original did not take cardinality,
-- start and end measure correctly into account. It has been recoded
-- using partial_chunk_connectivity
-- The comments have bene left because the new method will deliver
-- a connection when the other did not. This needs to be further
-- explored
-------------------------------------------
FUNCTION are_placements_connected (p_pl_1 nm_placement
                                  ,p_pl_2 nm_placement
                                  ) RETURN boolean IS
--
   CURSOR cs_connected (p_start_ne_id number
                       ,p_end_ne_id   number
                       ) IS
   SELECT 1
    FROM  dual
   WHERE  EXISTS (SELECT 1
                   FROM  nm_node_usages nnu_st
                        ,nm_node_usages nnu_end
                  WHERE  nnu_st.nnu_ne_id      = p_start_ne_id
                   AND   nnu_st.nnu_node_type  = 'S'
                   AND   nnu_end.nnu_ne_id     = p_end_ne_id
                   AND   nnu_end.nnu_node_type = 'E'
                   AND   nnu_st.nnu_no_node_id = nnu_end.nnu_no_node_id
                 );
   l_dummy binary_integer;
--
   l_retval boolean;
--
BEGIN
  nm_debug.proc_start(g_package_name,'are_placements_connected');
--   nm_debug.debug('#########################################');
--   nm_debug.debug('PL1 : '||p_pl_1.pl_ne_id||','||p_pl_1.pl_start||' -> '||p_pl_1.pl_end);
--   nm_debug.debug('PL2 : '||p_pl_2.pl_ne_id||','||p_pl_2.pl_start||' -> '||p_pl_2.pl_end);
--
   IF    p_pl_1.pl_ne_id  = p_pl_2.pl_ne_id
    THEN
      -- They are part of the same element
--      nm_debug.debug('They are part of the same element');
      IF  p_pl_1.pl_start = p_pl_2.pl_end
       OR p_pl_2.pl_start = p_pl_1.pl_end
       THEN
--         nm_debug.debug('The starts/ends match up exactly');
         -- The starts/ends match up exactly
         l_retval := TRUE;
      ELSE
         l_retval := FALSE;
      END IF;
   ELSE
--      nm_debug.debug('They are part of different elements');
      -- They are part of different elements
      IF    (p_pl_1.pl_start = 0 AND p_pl_2.pl_end = nm3net.get_datum_element_length(p_pl_2.pl_ne_id))
       THEN
--         nm_debug.debug('Begin MP of PL1 is 0');
         -- Begin MP of PL1 is 0
         -- End MP of PL2 is element end
         -- see if they share a node usage
         OPEN  cs_connected (p_pl_1.pl_ne_id, p_pl_2.pl_ne_id);
         FETCH cs_connected INTO l_dummy;
         l_retval := cs_connected%FOUND;
         CLOSE cs_connected;
      ELSIF (p_pl_2.pl_start = 0 AND p_pl_1.pl_end = nm3net.get_datum_element_length(p_pl_1.pl_ne_id))
       THEN
--         nm_debug.debug('Begin MP of PL2 is 0. End MP of PL1 is element end. see if they share a node usage');
--         nm_debug.debug(p_pl_2.pl_ne_id);
--         nm_debug.debug(p_pl_1.pl_ne_id);
         -- Begin MP of PL2 is 0
         -- End MP of PL1 is element end
         -- see if they share a node usage
--         nm_debug.debug('OPEN  cs_connected ('||p_pl_2.pl_ne_id||', '||p_pl_1.pl_ne_id||');');
         OPEN  cs_connected (p_pl_2.pl_ne_id, p_pl_1.pl_ne_id);
         FETCH cs_connected INTO l_dummy;
         l_retval := cs_connected%FOUND;
         CLOSE cs_connected;
      ELSE
--         nm_debug.debug('Not connected');
         -- Not connected
         l_retval := FALSE;
      END IF;
   END IF;
--
--   IF l_retval
--    THEN
--      nm_debug.debug('************************************* RETURNING TRUE');
--   END IF;
  nm_debug.proc_end(g_package_name,'are_placements_connected');
   RETURN l_retval;
--
END are_placements_connected;
--
*/
-----------------------------------------------------------------------------
--
FUNCTION get_pl_by_excl_sub_class (pi_st_lref   IN nm_lref
                                  ,pi_end_lref  IN nm_lref
                                  ,pi_route     IN nm_elements.ne_id%TYPE
                                  ,pi_sub_class IN nm_elements.ne_sub_class%TYPE
                                  ) RETURN nm_placement_array IS
--
   l_st_true  NUMBER := Nm3lrs.get_element_true (pi_route, pi_st_lref.lr_ne_id);
   l_end_true NUMBER := Nm3lrs.get_element_true (pi_route, pi_end_lref.lr_ne_id);
--
   l_st_seg    NUMBER := Nm3lrs.get_element_seg_no( pi_route, pi_st_lref.lr_ne_id );
   l_end_seg   NUMBER := Nm3lrs.get_element_seg_no( pi_route, pi_end_lref.lr_ne_id );
--
   CURSOR cs_middle_mem (c_route    nm_members.nm_ne_id_in%TYPE
                        ,c_subclass nm_elements.ne_sub_class%TYPE
                        ,c_min_true nm_members.nm_true%TYPE
                        ,c_max_true nm_members.nm_true%TYPE
                        ,c_first    nm_members.nm_ne_id_of%TYPE
                        ,c_last     nm_members.nm_ne_id_of%TYPE
                        ) IS
   SELECT nm_placement(nm_ne_id_of
                      ,nm_begin_mp
                      ,NVL(nm_end_mp,ne_length)
                      ,0
                      )
     FROM nm_members
         ,nm_elements
   WHERE  nm_ne_id_in  = c_route
    AND   nm_ne_id_of  = ne_id
    AND   ne_sub_class = c_subclass
    AND   nm_true      > c_min_true
    AND   nm_true      < c_max_true
    AND   nm_ne_id_of NOT IN (c_first, c_last)
   ORDER BY nm_seq_no;
--
   l_st_lref  nm_lref;
   l_end_lref nm_lref;
--
   CURSOR cs_mem (c_in    nm_members.nm_ne_id_in%TYPE
                 ,c_of    nm_members.nm_ne_id_of%TYPE
                 ,c_mp    nm_members.nm_begin_mp%TYPE
                 ) IS
   SELECT nm_placement(nm_ne_id_of
                      ,nm_begin_mp
                      ,NVL(nm_end_mp,ne_length)
                      ,0
                      )
         ,nm_cardinality
         ,ne_sub_class
    FROM  nm_members
         ,nm_elements
   WHERE  nm_ne_id_in = c_in
    AND   nm_ne_id_of = c_of
    AND   nm_ne_id_of = ne_id
    AND   c_mp BETWEEN nm_begin_mp AND NVL(nm_end_mp,ne_length);
--
   retval     nm_placement_array := Nm3pla.initialise_placement_array;
--
   l_pl       nm_placement;
   l_card     nm_members.nm_cardinality%TYPE;
   l_scl      nm_elements.ne_sub_class%TYPE;
--
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'get_pl_by_excl_sub_class');
--
--
   IF l_st_seg = l_end_seg
    THEN
--
      IF (pi_st_lref.lr_ne_id      = pi_end_lref.lr_ne_id
          AND pi_st_lref.lr_offset > pi_end_lref.lr_offset
         )
       OR l_st_true > l_end_true
       THEN
         g_pla_exc_code := -20041;
         g_pla_exc_msg  := 'Start position is further along the route than the end';
         RAISE g_pla_exception;
      END IF;
--
   ELSE
--
--  Different segment numbers, check true distance at start/end of segments
--
      IF Nm3lrs.min_seg_true( pi_route, l_end_seg ) <= Nm3lrs.max_seg_true( pi_route, l_st_seg )
       THEN
         g_pla_exc_code := -20042;
         g_pla_exc_msg  := 'Cannot establish connectivity between the start and end';
         RAISE g_pla_exception;
      END IF;
--
      IF l_st_true > l_end_true
       THEN
         g_pla_exc_code := -20041;
         g_pla_exc_msg  := 'Start position is further along the route than the end';
         RAISE g_pla_exception;
      END IF;
--
   END IF;
--
   l_st_lref  := pi_st_lref;
   l_end_lref := pi_end_lref;
--
   OPEN  cs_mem (pi_route, l_st_lref.lr_ne_id, l_st_lref.lr_offset);
--   nm_debug.debug(pi_route||':'||l_st_lref.lr_ne_id||':'||l_st_lref.lr_offset,-1);
   FETCH cs_mem INTO l_pl, l_card, l_scl;
   IF cs_mem%NOTFOUND
    THEN
      CLOSE cs_mem;
      g_pla_exc_code := -20044;
      g_pla_exc_msg  := 'This point on this datum not found on this route';
      RAISE g_pla_exception;
   END IF;
   CLOSE cs_mem;
--
   IF l_st_lref.lr_ne_id = l_end_lref.lr_ne_id
    THEN
      -- These are on the same datum
      IF l_scl = pi_sub_class
       THEN
         IF l_card = 1
          THEN
            l_pl.pl_start := l_st_lref.lr_offset;
            l_pl.pl_end   := l_end_lref.lr_offset;
         ELSE
            l_pl.pl_start := l_end_lref.lr_offset;
            l_pl.pl_end   := l_st_lref.lr_offset;
         END IF;
           add_element_to_pl_arr (pio_pl_arr => retval
                                 ,pi_pl      => l_pl
                                 ,pi_mrg_mem => TRUE
                                 );
      END IF;
   ELSE
--
      --
      -- Do the first one
      --
      IF l_scl = pi_sub_class
       THEN
         IF l_card = 1
          THEN
            l_pl.pl_start := l_st_lref.lr_offset;
         ELSE
            l_pl.pl_end   := l_st_lref.lr_offset;
         END IF;
           add_element_to_pl_arr (pio_pl_arr => retval
                                 ,pi_pl      => l_pl
                                 ,pi_mrg_mem => TRUE
                                 );
      END IF;
      --
      -- Do the middle ones
      --
      OPEN  cs_middle_mem (pi_route,pi_sub_class,l_st_true,l_end_true,l_st_lref.lr_ne_id,l_end_lref.lr_ne_id);
      FETCH cs_middle_mem INTO l_pl;
      WHILE cs_middle_mem%FOUND
       LOOP
           add_element_to_pl_arr (pio_pl_arr => retval
                                 ,pi_pl      => l_pl
                                 ,pi_mrg_mem => TRUE
                                 );
         FETCH cs_middle_mem INTO l_pl;
      END LOOP;
      CLOSE cs_middle_mem;
   --
      --
      -- Do the last one
      --
      OPEN  cs_mem (pi_route, l_end_lref.lr_ne_id, l_end_lref.lr_offset);
--    nm_debug.debug(pi_route||':'||l_end_lref.lr_ne_id||':'||l_end_lref.lr_offset,-1);
      FETCH cs_mem INTO l_pl, l_card, l_scl;
      IF cs_mem%NOTFOUND
       THEN
         CLOSE cs_mem;
         g_pla_exc_code := -20044;
         g_pla_exc_msg  := 'This point on this datum not found on this route';
         RAISE g_pla_exception;
      END IF;
      CLOSE cs_mem;
      IF l_scl = pi_sub_class
       THEN
         IF l_card = 1
          THEN
            l_pl.pl_end   := l_end_lref.lr_offset;
         ELSE
            l_pl.pl_start := l_end_lref.lr_offset;
         END IF;
         IF l_pl.pl_start != l_pl.pl_end
          THEN
           add_element_to_pl_arr (pio_pl_arr => retval
                                 ,pi_pl      => l_pl
                                 ,pi_mrg_mem => TRUE
                                 );
         END IF;
      END IF;
   END IF;
--
-- nm_debug.proc_end(g_package_name,'get_pl_by_excl_sub_class');
--
   RETURN retval;
--
EXCEPTION
--
   WHEN g_pla_exception
    THEN
      RAISE_APPLICATION_ERROR(g_pla_exc_code,g_pla_exc_msg);
--
END get_pl_by_excl_sub_class;
--
-----------------------------------------------------------------------------
--
FUNCTION get_pl_by_excl_sub_class (pi_route     IN nm_elements.ne_id%TYPE
                                  ,pi_st_true   IN nm_members.nm_true%TYPE
                                  ,pi_end_true  IN nm_members.nm_true%TYPE
                                  ,pi_sub_class IN nm_elements.ne_sub_class%TYPE
                                  ) RETURN nm_placement_array IS
--
   l_st_lref  nm_lref := nm_lref(NULL,NULL);
   l_end_lref nm_lref := nm_lref(NULL,NULL);
--
   retval nm_placement_array := initialise_placement_array;
--
   l_max_true nm_members.nm_true%TYPE;
--
   l_sanity_check NUMBER := 0;
--
   FUNCTION find_lref (pi_route      nm_elements.ne_id%TYPE
                      ,pi_true      nm_members.nm_true%TYPE
                      ,pi_sub_class nm_elements.ne_sub_class%TYPE
                      ) RETURN nm_lref IS
      --
      CURSOR cs_best_fit (c_route nm_members.nm_ne_id_in%TYPE
                         ,c_true  nm_members.nm_true%TYPE
                         ,c_scl   nm_elements.ne_sub_class%TYPE
                         ) IS
      SELECT nm_ne_id_of
            ,ne_sub_class
            ,nm_true
            ,nm_cardinality
            ,nm_begin_mp
            ,nm_end_mp
        FROM nm_members
            ,nm_elements ne_child
       WHERE nm_ne_id_in         = c_route
        AND  nm_true            <= c_true
        AND  nm_ne_id_of         = ne_child.ne_id
        AND  ne_sub_class        = NVL(c_scl,ne_sub_class)
       ORDER BY nm_true DESC;
      --
      l_rec_best_fit cs_best_fit%ROWTYPE;
      --
      no_translation EXCEPTION;
      PRAGMA EXCEPTION_INIT (no_translation,-20001);
      l_retval nm_lref := nm_lref(NULL,NULL);
      --
   BEGIN
      --
       l_sanity_check := l_sanity_check + 1;
       --
       -- Check for an exact match
       --
       OPEN  cs_best_fit (pi_route,pi_true,pi_sub_class);
       FETCH cs_best_fit INTO l_rec_best_fit;
       -- If this point is at a node
       IF   cs_best_fit%FOUND
        AND l_rec_best_fit.nm_true = pi_true
        THEN
          CLOSE cs_best_fit;
          l_retval.lr_ne_id := l_rec_best_fit.nm_ne_id_of;
          IF l_rec_best_fit.nm_cardinality = 1
           THEN
             l_retval.lr_offset := l_rec_best_fit.nm_begin_mp;
          ELSE
             l_retval.lr_offset := l_rec_best_fit.nm_end_mp;
          END IF;
       ELSE
          CLOSE cs_best_fit;
          -- Look for one with the correct sub class first of all
          l_retval := Nm3lrs.get_datum_mp_from_route_true (pi_ne_id     => pi_route
                                                          ,pi_true      => pi_true
                                                          ,pi_sub_class => pi_sub_class
                                                          );
       END IF;
      --
       RETURN l_retval;
      --
   EXCEPTION
      WHEN no_translation
       THEN
         g_pla_exc_code := SQLCODE;
         g_pla_exc_msg  := SQLERRM;
         IF l_sanity_check > 1
          THEN
            g_pla_exc_msg  := l_sanity_check||'-'||g_pla_exc_msg;
            RAISE g_pla_exception;
         END IF;
         -- We've not found one with the correct sub class, so have a go for the best fit
         OPEN  cs_best_fit (pi_route,pi_true,NULL);
         FETCH cs_best_fit INTO l_rec_best_fit;
         IF cs_best_fit%NOTFOUND
          THEN
            CLOSE cs_best_fit;
            RAISE g_pla_exception;
         END IF;
         CLOSE cs_best_fit;
         l_retval := find_lref (pi_route, pi_true, l_rec_best_fit.ne_sub_class);
         RETURN l_retval;
   END find_lref;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'get_pl_by_excl_sub_class');
--
   --
   -- Check that the true distances exist on the route
   --
   l_max_true := Nm3net.get_max_true(pi_route);
--
--   nm_debug.debug('Max true    is : '||l_max_true,-2);
--   nm_debug.debug('pi_st_true  is : '||pi_st_true,-2);
--   nm_debug.debug('pi_end_true is : '||pi_end_true,-2);
   IF  pi_st_true  > l_max_true
    OR pi_end_true > l_max_true
    THEN
      g_pla_exc_code := -20045;
      g_pla_exc_msg  := 'Max Route True Distance '||l_max_true||' cannot evaluate '||pi_st_true||'->'||pi_end_true;
      RAISE g_pla_exception;
   END IF;
--
--  Get a LREF for both the start and end and then call the overloaded one
--
   l_sanity_check := 0;
   l_st_lref  := find_lref(pi_route,pi_st_true,pi_sub_class);
   l_sanity_check := 0;
   l_end_lref := find_lref(pi_route,pi_end_true,pi_sub_class);
   l_sanity_check := 0;
--
   retval := get_pl_by_excl_sub_class (pi_st_lref   => l_st_lref
                                      ,pi_end_lref  => l_end_lref
                                      ,pi_route     => pi_route
                                      ,pi_sub_class => pi_sub_class
                                      );
--
   Nm_Debug.proc_end(g_package_name,'get_pl_by_excl_sub_class');
--
   RETURN retval;
--
EXCEPTION
--
   WHEN g_pla_exception
    THEN
      RAISE_APPLICATION_ERROR(g_pla_exc_code,g_pla_exc_msg);
--
END get_pl_by_excl_sub_class;
--
-----------------------------------------------------------------------------
--
FUNCTION chunk_connectivity( rvrs IN BOOLEAN,
                             c1 IN NUMBER,
                             c2 IN NUMBER,
                             p1 IN NUMBER,
                             p2 IN NUMBER ) RETURN BOOLEAN IS

retval BOOLEAN := FALSE;
dcon   INTEGER := defrag_connectivity( p1, p2);
card   BOOLEAN := ( c1 = c2 );

BEGIN
--  nm_debug.debug_on;
--  nm_debug.debug( 'Check connectivity '||TO_CHAR( dcon ));

/*
IF card THEN
   nm_debug.debug('Same direction');
ELSE
   nm_debug.debug('Diff direction');
END IF;
*/
  IF dcon = 0 THEN
--  nm_debug.debug('not connected');
    retval := FALSE;
  ELSE
    IF rvrs THEN
      retval := TRUE;
    ELSIF ABS(dcon ) = 1 THEN
	    retval := TRUE;
    END IF;
  END IF;
  RETURN retval;
END;
--
FUNCTION partial_chunk_connectivity(rvrs IN BOOLEAN,
                             p1 IN NUMBER,
                             d1 in integer,
                             p2 IN NUMBER,
                             d2 in integer,
                             s1 IN NUMBER,
                             e1 IN NUMBER,
                             s2 IN NUMBER,
                             e2 IN NUMBER  ) RETURN integer IS


cursor c_connectivity ( c_ne_1 nm_elements.ne_id%TYPE,
            c_ne_2 nm_elements.ne_id%TYPE,
            d1 in integer,
            d2 in integer,
            s1 in number,
            e1 in number,
            s2 in number,
            e2 in number ) is 
select 1 from 
(
select t.*,
  case e1dir
    when 1 then s1
    else   e1
    end ep1,
  case e2dir
    when 1 then s2
    else   e2
    end ep2
from (     
     SELECT Nm3net.get_type_sign( a1.nnu_node_type ) e1dir,
            Nm3net.get_type_sign( a2.nnu_node_type ) e2dir, 
            a1.nnu_chain n1m, a2.nnu_chain n2m
     FROM nm_node_usages a1, nm_node_usages a2
     WHERE a1.nnu_ne_id = c_ne_1
     AND   a2.nnu_ne_id = c_ne_2
     AND   a1.nnu_no_node_id = a2.nnu_no_node_id ) t )
--where  (e1dir * d1 ) = (e2dir * d2 )
where e2dir * d2 > 0
and n1m = ep1
and n2m = ep2;      

retval integer := 0;

BEGIN

  open c_connectivity(p1, p2, d1, d2, s1, e1, s2, e2);
  fetch c_connectivity into retval;
  if c_connectivity%notfound then
    retval := 0;
  end if;
  close c_connectivity;
  return retval;
end;  
--

FUNCTION partial_chunk_connectivity(rvrs IN integer,
                             p1 IN NUMBER,

                             p2 IN NUMBER,
                             d1 in integer,
                             d2 in integer,
                             s1 IN NUMBER,
                             e1 IN NUMBER,
                             s2 IN NUMBER,
                             e2 IN NUMBER  ) RETURN integer IS


cursor c_connectivity ( 

            p1 in number,
            p2 in number,
            d1 in integer,
            d2 in integer,
            s1 in number,
            e1 in number,
            s2 in number,
            e2 in number ) is 
select 
--decode( stype1||etype1, 'ES', 1, 'EE', 2, 'SE' -1, 'SS' -2, -99 )  retval1
--     t.*,

--     decode( stype||etype, 'ES', 1, 'EE', 2, 'SE' -1, 'SS' -2 )  retval,  
  case  stype1 
    when etype1 then
      case stype1
        when 'E' then 2
        else -2
      end
    else
      case stype1
        when 'E' then 1
        else -1
      end
  end retval1
from (     
     SELECT a1.nnu_node_type stype,
            case nvl(d1, -99)
              when -99 then a1.nnu_node_type
              when 1    then a1.nnu_node_type
              when -1   then decode (a1.nnu_node_type, 'S', 'E', 'E', 'S' )
            end stype1,
            case a1.nnu_node_type
              when 'S' then s1
              else e1



              end m1,
            a2.nnu_node_type etype,
            case nvl(d2, -99)
              when -99 then a2.nnu_node_type
              when 1    then a2.nnu_node_type
              when -1   then decode (a2.nnu_node_type, 'S', 'E', 'E', 'S' )
            end etype1,
            case a2.nnu_node_type
              when 'S' then s2
              else e2




              end m2,
            a1.nnu_chain n1m, a2.nnu_chain n2m
     FROM nm_node_usages a1, nm_node_usages a2
     WHERE a1.nnu_ne_id = p1
     AND   a2.nnu_ne_id = p2
     AND   a1.nnu_no_node_id = a2.nnu_no_node_id         



     ) t     
where n1m = nvl(m1, n1m)
  and n2m = nvl(m2, n2m)
order by decode (retval1, 1, 1, -1, 2, 3 );

retval integer := 0;

BEGIN

/*
nm_debug.debug_on;
nm_debug.debug(p1||','||p2||','||d1||','||d2||','||s1||','||e1||','||s2||','||e2);
*/
  open c_connectivity(p1, p2, d1, d2, s1, e1, s2, e2);
  fetch c_connectivity into retval;
  if c_connectivity%notfound then
    retval := 0;
  end if;
  close c_connectivity;
  if rvrs = 0 and retval != 1 then
    retval := 0;
  end if; 
  return retval;
end;
--

--
FUNCTION partial_chunk_connectivity( rvrs IN BOOLEAN,
                             p1 IN NUMBER,
                             p2 IN NUMBER,
							 s1 IN NUMBER,
							 e1 IN NUMBER,
							 s2 IN NUMBER,
							 e2 IN NUMBER  ) RETURN BOOLEAN IS

retval BOOLEAN := FALSE;
dcon   INTEGER := defrag_connectivity( p1, p2);

BEGIN
--  nm_debug.debug_on;
--  nm_debug.debug( 'Check connectivity '||TO_CHAR( dcon ));

  IF dcon = 0 THEN
--  nm_debug.debug('not connected');
    retval := FALSE;
  ELSE
    IF rvrs THEN
      IF dcon = 1 AND e1 = Nm3net.Get_Ne_Length( p1 ) AND s2 = 0 THEN
  	    retval := TRUE;
	  ELSIF dcon = -1 AND s1 = 0 AND e2 = Nm3net.Get_Ne_Length( p2 ) THEN
	    retval := TRUE;
	  ELSIF dcon = 2 AND s1 = 0 AND s2 = 0 THEN
	    retval := TRUE;
	  ELSIF dcon  = -2 AND e1 = Nm3net.Get_Ne_Length( p1 ) AND e2 = Nm3net.Get_Ne_Length( p2 ) THEN
	    retval := TRUE;
      ELSE
	    retval := FALSE;
	  END IF;
    ELSIF ABS( dcon ) = 2  THEN
	  retval := FALSE;
    ELSE
--    cardinality the same and connected
      IF dcon > 0 AND e1 = Nm3net.Get_Ne_Length( p1 ) AND s2 = 0 THEN
  	    retval := TRUE;
	  ELSIF dcon <0 AND s1 = 0 AND e2 = Nm3net.Get_Ne_Length( p2 ) THEN
	    retval := TRUE;
	  ELSE
	    retval := FALSE;
	  END IF;
    END IF;
  END IF;
  RETURN retval;
END;
-----------------------------------------------------------------------------
--
FUNCTION defrag_connectivity
           (pi_ne_id1 IN nm_node_usages.nnu_ne_id%TYPE
           ,pi_ne_id2 IN nm_node_usages.nnu_ne_id%TYPE
           ) RETURN INTEGER IS
--
--
   CURSOR c_connectivity( c_ne_1 nm_elements.ne_id%TYPE,
                          c_ne_2 nm_elements.ne_id%TYPE ) IS
     SELECT a2.nnu_node_type, Nm3net.get_type_sign( a1.nnu_node_type ),
                              Nm3net.get_type_sign( a2.nnu_node_type )
     FROM nm_node_usages a1, nm_node_usages a2
     WHERE a1.nnu_ne_id = c_ne_1
     AND   a2.nnu_ne_id = c_ne_2
     AND   a1.nnu_no_node_id = a2.nnu_no_node_id order by 2;

   l_type1 nm_node_usages.nnu_node_type%TYPE;

   l1 INTEGER;
   l2 INTEGER;

   retval INTEGER;

BEGIN
--
   OPEN c_connectivity( pi_ne_id1, pi_ne_id2 );
   FETCH c_connectivity INTO l_type1, l1, l2;
   IF c_connectivity%NOTFOUND THEN
     retval := 0;
   ELSE
     IF l1 = l2 THEN
       retval := 2*l2;
     ELSE
       retval := 1*l2;
     END IF;
   END IF;
   CLOSE c_connectivity;
   RETURN retval;

END defrag_connectivity;
--
-----------------------------------------------------------------------------
--
FUNCTION get_pl_from_mrg_section (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                                 ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                                 ) RETURN nm_placement_array IS
--
   l_pl nm_placement_array;
--
BEGIN
--
   l_pl := initialise_placement_array;
--
   FOR cs_rec IN (SELECT *
                   FROM  nm_mrg_section_members
                  WHERE  nsm_mrg_job_id     = pi_nms_mrg_job_id
                   AND   nsm_mrg_section_id = pi_nms_section_id
                  ORDER BY nsm_measure
                 )
    LOOP
           add_element_to_pl_arr (pio_pl_arr => l_pl
                                 ,pi_ne_id   => cs_rec.nsm_ne_id
                                 ,pi_start   => cs_rec.nsm_begin_mp
                                 ,pi_end     => cs_rec.nsm_end_mp
                                 ,pi_measure => cs_rec.nsm_measure
                                 ,pi_mrg_mem => FALSE
                                 );
   END LOOP;
--
   RETURN l_pl;
--
END get_pl_from_mrg_section;
--
-----------------------------------------------------------------------------
--
FUNCTION remove_pl_from_pl_arr (pi_pl_arr IN nm_placement_array
                               ,pi_pl     IN nm_placement
                               ) RETURN nm_placement_array IS
--
   l_retval nm_placement_array := Nm3pla.initialise_placement_array;
   l_pl     nm_placement;
   l_new_pl nm_placement       := Nm3pla.initialise_placement;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'remove_pl_from_pl_arr');
--
   DECLARE
      l_nothing_to_do EXCEPTION;
   BEGIN
   --
      IF  pi_pl.pl_ne_id IS NULL
       OR pi_pl.pl_start IS NULL
       OR pi_pl.pl_end   IS NULL
       THEN
         RAISE l_nothing_to_do;
      END IF;
   --
      IF pi_pl.pl_start > pi_pl.pl_end
       THEN
         RAISE_APPLICATION_ERROR(-20001,'Start MP cannot be after End MP :'||pi_pl.pl_start||' > '||pi_pl.pl_end);
      END IF;
   --
      FOR i IN 1..pi_pl_arr.placement_count
       LOOP
         l_pl := pi_pl_arr.get_entry(i);
         IF l_pl.pl_ne_id = pi_pl.pl_ne_id
          THEN
            IF    l_pl.pl_start  = l_pl.pl_end
             AND  pi_pl.pl_start = pi_pl.pl_end
             --AND  l_pl.pl_start  = l_pl.pl_start
             AND  l_pl.pl_start  = pi_pl.pl_start
             THEN
               -- If this is a point and the one in the array is a point then remove it
               NULL;
            ELSIF l_pl.pl_end < pi_pl.pl_start
             THEN
               --
               -- This placement ends before the start of the chunk to remove
               --
              add_element_to_pl_arr (pio_pl_arr => l_retval
                                    ,pi_pl      => l_pl
                                    ,pi_mrg_mem => TRUE
                                    );
            ELSIF l_pl.pl_start > pi_pl.pl_end
             THEN
               --
               -- This placement starts after the end of the chunk to remove
               --
              add_element_to_pl_arr (pio_pl_arr => l_retval
                                    ,pi_pl      => l_pl
                                    ,pi_mrg_mem => TRUE
                                    );
            ELSE
               --
               -- This placement is affected
               --
--
               l_new_pl.pl_ne_id := l_pl.pl_ne_id;
--
               IF l_pl.pl_start < pi_pl.pl_start
                THEN
                  --
                  -- This placement starts before the one to remove
                  --
                  l_new_pl.pl_start   := l_pl.pl_start;
                  l_new_pl.pl_end     := pi_pl.pl_start;
                  l_new_pl.pl_measure := l_pl.pl_measure;
                 add_element_to_pl_arr (pio_pl_arr => l_retval
                                       ,pi_pl      => l_new_pl
                                       ,pi_mrg_mem => TRUE
                                       );
               END IF;
--
               IF l_pl.pl_end > pi_pl.pl_end
                THEN
                  --
                  -- This placement ends after the one to remove
                  --
                  l_new_pl.pl_start   := pi_pl.pl_end;
                  l_new_pl.pl_end     := l_pl.pl_end;
                  l_new_pl.pl_measure := 0;
                 add_element_to_pl_arr (pio_pl_arr => l_retval
                                       ,pi_pl      => l_new_pl
                                       ,pi_mrg_mem => TRUE
                                       );
               END IF;
--
            END IF;
         ELSE
            -- Different element - add regardless
                 add_element_to_pl_arr (pio_pl_arr => l_retval
                                       ,pi_pl      => l_pl
                                       ,pi_mrg_mem => TRUE
                                       );
         END IF;
      END LOOP;
--
      l_retval := defrag_placement_array(l_retval);
--
   EXCEPTION
      WHEN l_nothing_to_do
       THEN
         l_retval := pi_pl_arr;
   END;
--
   Nm_Debug.proc_end(g_package_name,'remove_pl_from_pl_arr');
--
   RETURN l_retval;
--
END remove_pl_from_pl_arr;
--
-----------------------------------------------------------------------------
--
FUNCTION subtract_pl_from_pl (p_pl_main      IN nm_placement_array
                             ,p_pl_to_remove IN nm_placement_array
                             ) RETURN nm_placement_array IS
--
   l_retval nm_placement_array := p_pl_main;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'subtract_pl_from_pl');
--
   DECLARE
      l_nothing_to_do EXCEPTION;
   BEGIN
      IF  p_pl_main.is_empty
       OR p_pl_to_remove.is_empty
       THEN
         -- If either of the passed placements are empty then there is nowt to do, so exit
         RAISE l_nothing_to_do;
      END IF;
--
      --
      -- Just loop through removing one placement at a time
      --
      FOR i IN 1..p_pl_to_remove.placement_count
       LOOP
         l_retval := remove_pl_from_pl_arr (l_retval, p_pl_to_remove.get_entry(i));
      END LOOP;
--
   EXCEPTION
      WHEN l_nothing_to_do
       THEN
         NULL;
   END;
--
   Nm_Debug.proc_end(g_package_name,'subtract_pl_from_pl');
--
   RETURN l_retval;
--
END subtract_pl_from_pl;
--
-------------------------------------------------------------------------------
--
FUNCTION get_measure_in_pl_arr (p_pl      IN nm_placement_array
                               ,p_lref    IN nm_lref
                               ) RETURN NUMBER IS
   CURSOR cs_check (c_ne_id NUMBER
                   ,c_mp    NUMBER
                   )  IS
   SELECT l_pl.pl_start
         ,l_pl.pl_end
         ,l_pl.pl_measure
    FROM  TABLE(CAST(p_pl.npa_placement_array AS nm_placement_array_type)) l_pl
   WHERE  l_pl.pl_ne_id = c_ne_id
    AND   c_mp BETWEEN l_pl.pl_start AND l_pl.pl_end;
   l_found    BOOLEAN;
--
   l_retval NUMBER;
   l_rec_chk cs_check%ROWTYPE;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'get_measure_in_pl_arr');
--
   OPEN  cs_check (p_lref.lr_ne_id, p_lref.lr_offset);
   FETCH cs_check INTO l_rec_chk;
   l_found := cs_check%FOUND;
   CLOSE cs_check;
   --
   l_retval := l_rec_chk.pl_measure + (p_lref.lr_offset-l_rec_chk.pl_start);
   --
   Nm_Debug.proc_end(g_package_name,'get_measure_in_pl_arr');
--
   RETURN l_retval;
--
END get_measure_in_pl_arr;
--
-------------------------------------------------------------------------------
--
FUNCTION get_lref_from_measure_in_plarr (p_pl        IN nm_placement_array
                                        ,p_measure   IN NUMBER
                                        ,p_st_or_end IN VARCHAR2 DEFAULT NULL
                                        ) RETURN nm_lref IS
--
   l_retval          nm_lref := nm_lref(NULL,NULL);
   l_possible_retval nm_lref := nm_lref(NULL,NULL);
   l_pl              nm_placement;
   l_found_good_one  BOOLEAN := FALSE;
--
   l_placement_length NUMBER;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'get_lref_from_measure_in_plarr');
--
   FOR i IN 1..p_pl.placement_count
    LOOP
      l_pl               := p_pl.get_entry(i);
      l_placement_length := (l_pl.pl_end-l_pl.pl_start);
      IF    l_pl.pl_measure + l_placement_length = p_measure
       THEN
         -- Only use this one if we find nothing better. Start of next element is better than end of this one.
         l_possible_retval := nm_lref(l_pl.pl_ne_id,l_pl.pl_end);
         --
         IF NVL(p_st_or_end,Nm3type.c_nvl) = 'E'
          THEN -- We're looking for an END
            l_retval         := l_possible_retval;
            l_found_good_one := TRUE;
         END IF;
         --
      ELSIF l_pl.pl_measure + l_placement_length > p_measure
       AND  l_pl.pl_measure                      < p_measure
       THEN
         l_retval          := nm_lref(l_pl.pl_ne_id,l_pl.pl_start+(p_measure-l_pl.pl_measure));
         l_found_good_one  := TRUE;
      ELSIF l_pl.pl_measure = p_measure
       THEN
         l_retval          := nm_lref(l_pl.pl_ne_id,l_pl.pl_start);
         l_found_good_one  := TRUE;
      END IF;
      EXIT WHEN l_found_good_one;
   END LOOP;
--
   IF NOT l_found_good_one
    THEN
      -- We've not found a brilliant match, but this one is a match
      l_retval := l_possible_retval;
   END IF;
--
--   IF l_retval.lr_ne_id IS NULL
--    THEN
--      hig.raise_ner('NET',28,null,'not found match for '||p_measure);
--   END IF;
--
   Nm_Debug.proc_end(g_package_name,'get_lref_from_measure_in_plarr');
--
   RETURN l_retval;
--
END get_lref_from_measure_in_plarr;
--
-----------------------------------------------------------------------------
--
FUNCTION get_pl_within_measures (p_pl       nm_placement_array
                                ,p_begin_mp NUMBER
                                ,p_end_mp   NUMBER
                                ) RETURN nm_placement_array IS
--
   l_pl_dummy nm_placement_array := Nm3pla.initialise_placement_array;
   l_retval   nm_placement_array := Nm3pla.initialise_placement_array;
--
   l_st_lref  nm_lref            := nm_lref(NULL,NULL);
   l_end_lref nm_lref            := nm_lref(NULL,NULL);
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'get_pl_within_measures');
--
   IF p_begin_mp >= p_end_mp
    THEN
      Hig.raise_ner (pi_appl               => Nm3type.c_net
                    ,pi_id                 => 276
                    ,pi_supplementary_info => p_begin_mp||' >= '||p_end_mp
                    );
   END IF;
--
   l_retval := Nm3pla.defrag_placement_array (p_pl);
--
   IF Nm3pla.count_pl_arr_connected_chunks(l_retval) > 1
    THEN
      Hig.raise_ner (pi_appl               => Nm3type.c_net
                    ,pi_id                 => 28
                    ,pi_supplementary_info => 'Can only operate on single connected extents'
                    );
   END IF;
--
   l_st_lref  := Nm3pla.get_lref_from_measure_in_plarr (l_retval, p_begin_mp);
   l_end_lref := Nm3pla.get_lref_from_measure_in_plarr (l_retval, p_end_mp, 'E');
--
   IF  l_st_lref.get_ne_id  IS NULL
    OR l_end_lref.get_ne_id IS NULL
    THEN
      Hig.raise_ner (pi_appl => Nm3type.c_net
                    ,pi_id   => 85
                    );
   END IF;
--
   Nm3pla.split_placement_array (this_npa                       => l_retval
                                ,pi_ne_id                       => l_st_lref.get_ne_id
                                ,pi_mp                          => l_st_lref.get_offset
                                ,po_npa_pre                     => l_pl_dummy
                                ,po_npa_post                    => l_retval
                                ,pi_allow_zero_length_placement => FALSE
                                );
   Nm3pla.split_placement_array (this_npa                       => l_retval
                                ,pi_ne_id                       => l_end_lref.get_ne_id
                                ,pi_mp                          => l_end_lref.get_offset
                                ,po_npa_pre                     => l_retval
                                ,po_npa_post                    => l_pl_dummy
                                ,pi_allow_zero_length_placement => FALSE
                                );
--
   l_retval := Nm3pla.defrag_placement_array (l_retval);
--
   Nm_Debug.proc_end(g_package_name,'get_pl_within_measures');
--
   RETURN l_retval;
--
END get_pl_within_measures;
--
-----------------------------------------------------------------------------
--

FUNCTION get_pl_from_rescale_write (pi_nm_seg_no nm_rescale_write.nm_seg_no%TYPE DEFAULT NULL
                                   ) RETURN nm_placement_array IS
--
   l_retval   nm_placement_array := Nm3pla.initialise_placement_array;
--
   l_tab_ne_id        Nm3type.tab_number;
   l_tab_nm_begin_mp  Nm3type.tab_number;
   l_tab_nm_end_mp    Nm3type.tab_number;
   l_tab_nm_true      Nm3type.tab_number;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'get_pl_from_rescale_write');
--
   SELECT ne_id
         ,nm_begin_mp
         ,nm_end_mp
         ,nm_true
    BULK  COLLECT
    INTO  l_tab_ne_id
         ,l_tab_nm_begin_mp
         ,l_tab_nm_end_mp
         ,l_tab_nm_true
    FROM  nm_rescale_write
   WHERE  nm_seg_no = NVL (pi_nm_seg_no, nm_seg_no)
   ORDER BY nm_seq_no;
--
   FOR i IN 1..l_tab_ne_id.COUNT
    LOOP
           add_element_to_pl_arr (pio_pl_arr => l_retval
                                 ,pi_ne_id   => l_tab_ne_id(i)
                                 ,pi_start   => l_tab_nm_begin_mp(i)
                                 ,pi_end     => l_tab_nm_end_mp(i)
                                 ,pi_measure => l_tab_nm_true(i)
                                 ,pi_mrg_mem => FALSE
                                 );
   END LOOP;
--
   Nm_Debug.proc_end(g_package_name,'get_pl_from_rescale_write');
--
   RETURN l_retval;
--
END get_pl_from_rescale_write;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_element_to_pl_arr (pio_pl_arr IN OUT NOCOPY nm_placement_array
                                ,pi_ne_id   IN            nm_elements.ne_id%TYPE
                                ,pi_start   IN            nm_members.nm_begin_mp%TYPE
                                ,pi_end     IN            nm_members.nm_end_mp%TYPE
                                ,pi_measure IN            nm_members.nm_true%TYPE DEFAULT 0
                                ,pi_mrg_mem IN            BOOLEAN                 DEFAULT TRUE
                                ) IS
--
   prior_ne_id   NUMBER;
   prior_start   NUMBER;
   prior_end     NUMBER;
   prior_measure NUMBER;
--
   l_start NUMBER := pi_start;
--
   l_extend_varray   BOOLEAN;
--
   c_max_array_count CONSTANT BINARY_INTEGER := 1048576;
--
BEGIN
--
-- If there are NO entries in the VARRAY then extend it
--
   IF pio_pl_arr.npa_placement_array.COUNT = 0
    THEN
      pio_pl_arr.npa_placement_array.EXTEND;
   END IF;
--
   -- get the start, end and measure of the previous section
   prior_ne_id   := NVL(pio_pl_arr.npa_placement_array(pio_pl_arr.npa_placement_array.LAST).pl_ne_id,0);
   prior_start   := NVL(pio_pl_arr.npa_placement_array(pio_pl_arr.npa_placement_array.LAST).pl_start,0);
   prior_end     := NVL(pio_pl_arr.npa_placement_array(pio_pl_arr.npa_placement_array.LAST).pl_end,0);
   prior_measure := NVL(pio_pl_arr.npa_placement_array(pio_pl_arr.npa_placement_array.LAST).pl_measure,0);
--
-- If the last element in the array has a NULL pi_ne_id, then just update this entry when the time comes
--
   l_extend_varray := (pio_pl_arr.npa_placement_array(pio_pl_arr.npa_placement_array.LAST).pl_ne_id IS NOT NULL);
--
   IF   pi_ne_id = prior_ne_id
    AND pi_start = prior_end
    AND pi_mrg_mem
    THEN
      --
      -- If this is the same NE and they are connected then update the previous record
      --  to have the pi_end set to this record
      -- i.e.  add_element for   NE_ID   START   END
      --                          123       0     20
      --                          123      20    120
      --                          123     120    200
      --                          123     220    500
      --                          354       0    300
      --  is stored as            123       0    200
      --                          123     220    500
      --                          354       0    300
      --
      l_start         := prior_start;
      l_extend_varray := FALSE;
   END IF;
   --
   -- If we are NOT just performing an update of the previous record
   --
   IF l_extend_varray
    THEN
      IF pio_pl_arr.npa_placement_array.COUNT = c_max_array_count
       THEN
         Hig.raise_ner (pi_appl               => Nm3type.c_net
                       ,pi_id                 => 28
                       ,pi_supplementary_info => 'Placement Array cannot have more than '||c_max_array_count||' entries'
                       );
      END IF;
      pio_pl_arr.npa_placement_array.EXTEND;
   END IF;
--
   pio_pl_arr.npa_placement_array(pio_pl_arr.npa_placement_array.LAST) := nm_placement (pi_ne_id
                                                                                       ,l_start
                                                                                       ,pi_end
                                                                                       ,pi_measure
                                                                                       );
--
END add_element_to_pl_arr;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_element_to_pl_arr (pio_pl_arr IN OUT NOCOPY nm_placement_array
                                ,pi_pl      IN            nm_placement
                                ,pi_mrg_mem IN            BOOLEAN                 DEFAULT TRUE
                                ) IS
BEGIN
--
   add_element_to_pl_arr (pio_pl_arr => pio_pl_arr
                         ,pi_ne_id   => pi_pl.pl_ne_id
                         ,pi_start   => pi_pl.pl_start
                         ,pi_end     => pi_pl.pl_end
                         ,pi_measure => pi_pl.pl_measure
                         ,pi_mrg_mem => pi_mrg_mem
                         );
--
END add_element_to_pl_arr;
--
-----------------------------------------------------------------------------
--
FUNCTION check_contiguity ( pi_ne_id       nm_elements.ne_id%TYPE
                          , pi_inv_type    nm_inv_items.iit_inv_type%TYPE
                          , pi_xsp         nm_inv_items.iit_x_sect%TYPE
                          , pi_route_datum VARCHAR)
RETURN BOOLEAN
IS
l_sql Varchar2(4000);
l_rowcount NUMBER;
--
BEGIN
   --  
   IF pi_route_datum = 'G'
   THEN    
       l_sql := ' Select count(*) FROM '||
                '  ( '||
                ' Select t.* '||
                ' FROM '||
                ' ( '||
                ' select cast ( collect (nm_placement( i.nm_ne_id_of, i.nm_begin_mp, i.nm_end_mp, 0)) as nm_placement_array_type) ipl_arr '||
                ' from nm_members i, nm_inv_items, nm_members g '||
                ' where i.nm_obj_type = '''||pi_inv_type||''''||
                ' and i.nm_ne_id_in = iit_ne_id '||
                ' and Nvl(iit_x_sect,''X'') = Nvl('''||pi_xsp||''', Nvl(iit_x_sect,''X'')) '||
                ' and i.nm_ne_id_of = g.nm_ne_id_of '||
                ' and g.nm_ne_id_in = '||pi_ne_id||') asset_data,  '||
                ' ( select cast ( collect (nm_placement( r.nm_ne_id_of, r.nm_begin_mp, r.nm_end_mp, 0)) as nm_placement_array_type) rpl_arr '||
                ' from nm_members r '||
                ' where r.nm_ne_id_in = '||pi_ne_id||
                '   and nm_ne_id_of IN ( select ne_id '||
                '    from nm_elements_all '||
                '   where ne_type <> ''D'') '||
                ' ) route_data, '||
                ' table (NM3PLA.SUBTRACT_PL_FROM_PL(nm_placement_array(rpl_arr), nm_placement_array(ipl_arr)).npa_placement_array) t '||
                ' )   '||
                ' WHERE pl_ne_id is not null';
   ELSE
        l_sql := ' Select count(*) FROM '||
                ' ( '||
                '  Select t.* '||
                '  FROM '||
                ' ( '||
                ' Select cast ( collect (nm_placement( i.nm_ne_id_of, i.nm_begin_mp, i.nm_end_mp, 0)) as nm_placement_array_type) ipl_arr '||
                ' From nm_members i, nm_inv_items '||
                ' Where i.nm_obj_type = '''||pi_inv_type||''''||
                ' And i.nm_ne_id_in = iit_ne_id '||
                ' And Nvl(iit_x_sect,''X'') = Nvl('''||pi_xsp||''', Nvl(iit_x_sect,''X'')) '||
                ' And i.nm_ne_id_of = '||pi_ne_id||
                ' ) asset_data, '||
                ' (Select nm_placement_array_type( nm_placement( ne_id, 0, ne_length, 0)) rpl_arr '||
                ' From nm_elements '||
                ' where ne_id = '||pi_ne_id||
                ' ) route_data, '||
                ' table (NM3PLA.SUBTRACT_PL_FROM_PL(nm_placement_array(rpl_arr), nm_placement_array(ipl_arr)).npa_placement_array) t '||
                ' ) '|| 
                ' WHERE pl_ne_id is not null ' ;
   END IF ;  
   --
   EXECUTE IMMEDIATE l_sql INTO L_ROWCOUNT;
   RETURN L_ROWCOUNT > 0;
END;
--
-----------------------------------------------------------------------------
--
END Nm3pla;
/
