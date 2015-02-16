CREATE OR REPLACE PACKAGE BODY nm3lrs 
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/pck/nm3lrs.pkb-arc   2.8   Feb 16 2015 10:52:06   Chris.Baugh  $
--       Module Name      : $Workfile:   nm3lrs.pkb  $
--       Date into PVCS   : $Date:   Feb 16 2015 10:52:06  $
--       Date fetched Out : $Modtime:   Feb 16 2015 09:46:06  $
--       Version          : $Revision:   2.8  $
--       Based on SCCS version : 1.45
-------------------------------------------------------------------------
--   Author : Rob Coupe
--
--  nm3lrs package
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
   --g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)nm3lrs.pkb	1.45 09/25/06"';
   g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.8  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3lrs';
--
   g_lrs_exception EXCEPTION;
   g_lrs_exc_code  number;
   g_lrs_exc_msg   varchar2(2000);
-----------------------------------------------------------------------------
--
 FUNCTION get_nm_row( p_nm_ne_id_in IN nm_elements.ne_id%TYPE,
                     p_nm_ne_id_of IN nm_elements.ne_id%TYPE,
                     p_nm_offset   IN nm_members.nm_begin_mp%TYPE ) RETURN nm_members%ROWTYPE;

--
-----------------------------------------------------------------------------
--
PROCEDURE get_ambiguous_lrefs_internal (p_parent_id    IN     number
                                       ,p_parent_units IN     number
                                       ,p_datum_units  IN     number
                                       ,p_offset       IN     number
                                       ,p_lrefs           OUT lref_table
                                       ,p_sub_class    IN     varchar2 DEFAULT NULL
                                       ,p_use_true     IN     boolean
                                       ,p_use_db       IN     varchar2
                                       );
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
  RETURN g_sccsid;
END;
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
FUNCTION get_start( p_unique IN varchar2 ) RETURN number IS

retval number := get_start( nm3net.get_ne_id( p_unique ));

BEGIN
   RETURN retval;
END;
--
-----------------------------------------------------------------------------
--
FUNCTION get_start( p_set_id IN number ) RETURN number IS

CURSOR c2 IS
SELECT s.ne_id
  FROM nm_elements s, nm_members m1
  WHERE  s.ne_id = m1.nm_ne_id_of
  AND    m1.nm_ne_id_in = p_set_id
  AND    NOT EXISTS ( SELECT 'x' FROM nm_elements c, nm_members m2
                     WHERE c.ne_id = m2.nm_ne_id_of
                     AND   m2.nm_ne_id_in = m1.nm_ne_id_in
                     AND   c.ne_id != s.ne_id
                     AND DECODE( m2.nm_cardinality, 1, c.ne_no_end, c.ne_no_start ) =
                         DECODE( m1.nm_cardinality, 1, s.ne_no_start, s.ne_no_end))
  ORDER BY m1.nm_seq_no;


CURSOR c3 IS
SELECT s.ne_id
  FROM nm_elements s, nm_members m1
  WHERE  s.ne_id = m1.nm_ne_id_of
  AND    m1.nm_ne_id_in = p_set_id
  AND    NOT EXISTS ( SELECT 'x' FROM nm_elements c, nm_members m2
                     WHERE c.ne_id = m2.nm_ne_id_of
                     AND   m2.nm_ne_id_in = m1.nm_ne_id_in
                     AND   c.ne_id != s.ne_id
                     AND c.ne_no_end = s.ne_no_start )
  ORDER BY m1.nm_seq_no;

l_ne_id number;
BEGIN

  IF nm3net.is_sub_class_used( nm3net.get_ne_gty( p_set_id ) ) THEN
--
--  attempt to match the sub-class
--
    OPEN c3;
    FETCH c3 INTO l_ne_id;
    IF c3%NOTFOUND THEN
      CLOSE c3;
      RAISE_APPLICATION_ERROR( -20001, 'No starting element found for '||TO_CHAR(p_set_id));
    END IF;
    CLOSE c3;

  ELSE
    OPEN c2;
    FETCH c2 INTO l_ne_id;
    IF c2%NOTFOUND THEN
      RAISE_APPLICATION_ERROR( -20001, 'No starting element found for '||TO_CHAR(p_set_id));
    END IF;
    CLOSE c2;
  END IF;
  RETURN l_ne_id;

END get_start;


/*
FUNCTION get_start( p_set_id IN NUMBER ) RETURN NUMBER IS

CURSOR c1 IS
  SELECT s.ne_id FROM NM_ELEMENTS s, NM_MEMBERS m1, NM_ELEMENTS g
  WHERE g.ne_id = p_set_id
  AND   s.ne_id = m1.nm_ne_id_of
  AND   g.ne_id = m1.nm_ne_id_in
  AND   NOT EXISTS ( SELECT 'x' FROM NM_ELEMENTS c, NM_MEMBERS m2
                     WHERE c.ne_no_end = s.ne_no_start
                     AND c.ne_id != s.ne_id
                     AND c.ne_id = m2.nm_ne_id_of
                     AND m2.nm_ne_id_in = m1.nm_ne_id_in );

retval NUMBER;

BEGIN

   OPEN c1;
   FETCH c1 INTO retval;
   IF c1%NOTFOUND THEN
     retval := -999;
   END IF;
   CLOSE c1;

   RETURN retval;
END;
*/
--
-----------------------------------------------------------------------------
--
FUNCTION get_element_offset( p_ne_id_in IN number, p_ne_id_of IN number) RETURN number IS
  CURSOR c1 IS
    SELECT nm_slk
    FROM nm_members
    WHERE nm_ne_id_in = p_ne_id_in
    AND   nm_ne_id_of = p_ne_id_of;
retval number;
BEGIN
  OPEN c1;
  FETCH c1 INTO retval;
  CLOSE c1;
  RETURN retval;
END;
--
-----------------------------------------------------------------------------
--
FUNCTION get_element_true( p_ne_id_in IN number, p_ne_id_of IN number) RETURN number IS
  CURSOR c1 IS
    SELECT nm_true
    FROM nm_members
    WHERE nm_ne_id_in = p_ne_id_in
    AND   nm_ne_id_of = p_ne_id_of;
retval number;
BEGIN
  OPEN c1;
  FETCH c1 INTO retval;
  CLOSE c1;
  RETURN retval;
END;
--
-----------------------------------------------------------------------------
--
FUNCTION get_element_seg_no( p_ne_id_in IN number, p_ne_id_of IN number) RETURN number IS
  CURSOR c1 IS
    SELECT nm_seg_no
    FROM nm_members
    WHERE nm_ne_id_in = p_ne_id_in
    AND   nm_ne_id_of = p_ne_id_of;
retval number;
BEGIN
  OPEN c1;
  FETCH c1 INTO retval;
  CLOSE c1;
  RETURN retval;
END;
--
-----------------------------------------------------------------------------
--
FUNCTION get_element_seq_no( p_ne_id_in IN number, p_ne_id_of IN number) RETURN number IS
  CURSOR c1 IS
    SELECT nm_seq_no
    FROM nm_members
    WHERE nm_ne_id_in = p_ne_id_in
    AND   nm_ne_id_of = p_ne_id_of;
retval number;
BEGIN
  OPEN c1;
  FETCH c1 INTO retval;
  CLOSE c1;
  RETURN retval;
END;
--
-----------------------------------------------------------------------------
--
FUNCTION get_set_offset_internal (p_ne_parent_id IN number
                                 ,p_ne_child_id  IN number
                                 ,p_offset       IN number
                                 ,p_slk_reqd     IN boolean
                                 ) RETURN number IS
--
-- CS_SLK and CS_TRUE must be kept identical (apart from one selecting NM_SLK
--  and the other NM_TRUE)
--
  CURSOR cs_slk IS
  SELECT nm_slk
        ,nm_cardinality
        ,ne_length
        ,ne_nt_type
        ,nm_begin_mp
        ,nm_end_mp
   FROM  nm_members
        ,nm_elements
   WHERE nm_ne_id_in = p_ne_parent_id
    AND  nm_ne_id_of = p_ne_child_id
    AND  nm_ne_id_of = ne_id;
--
  CURSOR cs_true IS
  SELECT nm_true
        ,nm_cardinality
        ,ne_length
        ,ne_nt_type
        ,nm_begin_mp
        ,nm_end_mp
   FROM  nm_members
        ,nm_elements
   WHERE nm_ne_id_in = p_ne_parent_id
    AND  nm_ne_id_of = p_ne_child_id
    AND  nm_ne_id_of = ne_id;
--
  l_slk           nm_members.nm_slk%TYPE;
  l_cardinal      nm_members.nm_cardinality%TYPE;
  l_length        nm_elements.ne_length%TYPE;
  l_child_nt_type nm_elements.ne_nt_type%TYPE;
  l_nm_begin_mp   nm_members.nm_begin_mp%TYPE;
  l_nm_end_mp     nm_members.nm_end_mp%TYPE;
--
  retval     number;
--
  l_p_unit   number;
  l_c_unit   number;
  l_rec_ne   nm_elements%ROWTYPE;
--
  l_difference number;
--
   FUNCTION local_get_nt_units (p_nt_type nm_elements.ne_nt_type%TYPE) RETURN nm_units.un_unit_id%TYPE IS
      l_retval nm_units.un_unit_id%TYPE;
   BEGIN
      DECLARE
         l_not_found EXCEPTION;
         PRAGMA EXCEPTION_INIT(l_not_found,-20003);
      BEGIN
         l_retval := nm3net.get_nt_units (p_nt_type);
      EXCEPTION
         WHEN l_not_found
          THEN
            RAISE_APPLICATION_ERROR(-20003,nm3flx.parse_error_message(SQLERRM,'ORA',1)||'"'||NVL(p_nt_type,'#Null#')||'"');
      END;
      RETURN l_retval;
   END local_get_nt_units;
--
BEGIN
--
   IF p_ne_parent_id = p_ne_child_id
    THEN
--
      retval := p_offset;
--
   ELSE
--
      IF p_slk_reqd
       THEN
         OPEN  cs_slk;
         FETCH cs_slk INTO l_slk, l_cardinal, l_length, l_child_nt_type, l_nm_begin_mp, l_nm_end_mp;
         CLOSE cs_slk;
      ELSE
         OPEN  cs_true;
         FETCH cs_true INTO l_slk, l_cardinal, l_length, l_child_nt_type, l_nm_begin_mp, l_nm_end_mp;
         CLOSE cs_true;
      END IF;
      --
      IF l_child_nt_type IS NULL
       THEN
         retval := -1;
      ELSE
         l_c_unit := local_get_nt_units (l_child_nt_type);
--
         DECLARE
            element_not_found EXCEPTION;
            PRAGMA EXCEPTION_INIT(element_not_found,-20001);
         BEGIN
            l_rec_ne := nm3net.get_ne (p_ne_parent_id);
            BEGIN
               l_p_unit := nm3net.get_gty_units( l_rec_ne.ne_gty_group_type );
            EXCEPTION
               WHEN others
                THEN
                  l_p_unit := local_get_nt_units( l_rec_ne.ne_nt_type );
            END;
         EXCEPTION
            WHEN element_not_found
             THEN
               -- This must be linear inventory
               l_p_unit := l_c_unit;
         END;
         --

         --
         IF l_cardinal = 1
          THEN
            l_difference := (p_offset-l_nm_begin_mp);
         ELSE
            l_difference :=  l_nm_end_mp - p_offset;
         END IF;
   --
         IF l_c_unit = l_p_unit
          THEN
            retval := l_slk + l_difference;
         ELSIF l_c_unit IS NULL
          OR   l_p_unit IS NULL
          THEN
            retval := -1;
         ELSE
            retval := l_slk + nm3unit.convert_unit( l_c_unit, l_p_unit, l_difference);
         END IF;
      END IF;
--
   END IF;
--
   RETURN retval;
--
END get_set_offset_internal;
--
-----------------------------------------------------------------------------
--
FUNCTION get_set_offset (p_ne_parent_id IN number
                        ,p_ne_child_id  IN number
                        ,p_offset       IN number
                        ) RETURN number IS
BEGIN
   RETURN get_set_offset_internal (p_ne_parent_id => p_ne_parent_id
                                  ,p_ne_child_id  => p_ne_child_id
                                  ,p_offset       => p_offset
                                  ,p_slk_reqd     => TRUE
                                  );
END get_set_offset;
--
-----------------------------------------------------------------------------
--
FUNCTION get_set_offset_true (p_ne_parent_id IN number
                             ,p_ne_child_id  IN number
                             ,p_offset       IN number
                             ) RETURN number IS
BEGIN
   RETURN get_set_offset_internal (p_ne_parent_id => p_ne_parent_id
                                  ,p_ne_child_id  => p_ne_child_id
                                  ,p_offset       => p_offset
                                  ,p_slk_reqd     => FALSE
                                  );
END get_set_offset_true;
--
-----------------------------------------------------------------------------
--
--This function assumes that the set is a set of datum records
FUNCTION get_datum_offset( p_parent_lr IN nm_lref ) RETURN nm_lref IS
--
   l_parent_units number;
--
   l_offset       number;
   l_ne_id        number;
   
   l_ne_row       nm_elements%rowtype;
--
   retval         nm_lref;
BEGIN
--
   l_ne_row       := nm3get.get_ne(p_parent_lr.lr_ne_id);
   
   if NM3NET.IS_NT_DATUM( l_ne_row.ne_nt_type ) = 'Y' then
   
      retval := p_parent_lr;  -- return self;
      
   else
   
     l_parent_units := nm3net.get_nt_units (l_ne_row.ne_nt_type );

     BEGIN
       SELECT nm_ne_id_of
            ,DECODE(nm_cardinality
                   ,1,child_offset + nm_begin_mp
                   ,nm_end_mp - child_offset
                   ) datum_offset
       INTO  l_ne_id
            ,l_offset
       FROM (SELECT nm_ne_id_of
                   ,nm_slk
                   ,nm_begin_mp
                   ,nm_end_mp
                   ,nm_cardinality
                   ,nm3unit.convert_unit(l_parent_units
                                        ,nt_length_unit
                                        ,p_parent_lr.lr_offset - nm_slk
                                        ) child_offset
              FROM  nm_members
                   ,nm_elements
                   ,nm_types
             WHERE  nm_ne_id_in = p_parent_lr.lr_ne_id
              AND   p_parent_lr.lr_offset BETWEEN nm_slk AND nm_end_slk
              AND   nm_ne_id_of = ne_id
              AND   ne_nt_type  = nt_type
            );
     EXCEPTION
       WHEN no_data_found
       THEN -- No translation for linear reference
         hig.raise_ner (pi_appl    => nm3type.c_net
                       ,pi_id      => 85
                       ,pi_sqlcode => -20001
                       );
       WHEN too_many_rows
       THEN -- Ambiguous linear reference
         hig.raise_ner (pi_appl    => nm3type.c_net
                       ,pi_id      => 312
                       ,pi_sqlcode => -20002
                       );
     END;
   
     retval := nm_lref(l_ne_id,l_offset);
  
   END IF;
--
   RETURN retval; 
--
END get_datum_offset;
--
-----------------------------------------------------------------------------
--
FUNCTION get_distinct_offset(p_parent_lr IN nm_lref
                            ,p_use_db    IN varchar2 DEFAULT 'FALSE'
                            ) RETURN nm_lref IS

l_nt_type nm_types.nt_type%TYPE := nm3net.get_nt_type( p_parent_lr.lr_ne_id );
l_parent_units number           := nm3net.get_nt_units(l_nt_type);

l_child_units  number;
l_offset       number;

CURSOR c1 (c_parent_units number
          ,c_offset       number
          ,c_ne_id        number
          ,c_use_db       varchar2) IS
  SELECT nm_ne_id_of, nm_cardinality, ne_no_start, ne_no_end,
         nm3unit.convert_unit(c_parent_units, nm3net.get_nt_units( nm3net.get_nt_type( ne_id )), nm_slk), 
         ne_length,
		 nm_begin_mp, NVL(nm_end_mp, ne_length), ne_type
  FROM nm_members, nm_elements
  WHERE nm_ne_id_in = c_ne_id
  AND   nm_ne_id_of = ne_id
  AND   decode( c_use_db, 'FALSE', 'D', nm3type.c_nvl ) != ne_type
  AND   c_offset BETWEEN nm_slk AND nm_end_slk
  ORDER BY ne_type DESC, nm_slk;

l1_slk         number;
l1_ne_id       number;
l1_cardinal    number;
l1_length      number;
l1_start       number;
l1_end         number;
l1_begin_mp    number;
l1_end_mp      number;
l1_type        nm_types.nt_type%TYPE;

l2_slk         number;
l2_ne_id       number;
l2_cardinal    number;
l2_length      number;
l2_start       number;
l2_end         number;
l2_begin_mp    number;
l2_end_mp      number;
l2_type        nm_types.nt_type%TYPE;

retval         nm_lref;

BEGIN
  OPEN c1( l_parent_units, p_parent_lr.lr_offset, p_parent_lr.lr_ne_id, p_use_db);
  FETCH c1 INTO l1_ne_id, l1_cardinal, l1_start, l1_end, l1_slk, l1_length, l1_begin_mp, l1_end_mp, l1_type;

  --dbms_output.put_line( 'Id = '||TO_CHAR( l1_ne_id )||' Offset = '||TO_CHAR( l1_slk ));

  IF c1%NOTFOUND THEN
    CLOSE c1;
    RAISE_APPLICATION_ERROR(-20001, 'No translation for linear reference');
  ELSE
    FETCH c1 INTO l2_ne_id, l2_cardinal, l2_start, l2_end, l2_slk, l2_length, l2_begin_mp, l2_end_mp, l2_type;
    IF c1%NOTFOUND THEN
      CLOSE c1;
    ELSE
      CLOSE c1;
--
--    The ambiguity could be caused by the linear reference being coincident with the node between the
--    two network elements.
--

/*
      dbms_output.put_line( 'Checking for ambiguity');
      dbms_output.put_line( to_char(l1_slk)||' '||
                            to_char(l1_start)||' '||
                            to_char(l1_end)||' '||
                            to_char(l1_length)||' '||
                            to_char(l2_start) ||' '||
                            to_char(l2_end)||' '||
                            to_char(l2_length)||' '||
                            to_char(l2_slk) );
*/

/****************************************************************************************************
* SSCANLON fix 38036 19-SEP-2006
* datums with opposing or reverse cardinality would always return 'Ambiguous linear reference'.
* This was because the IF statement below as only checking if the start of one datum was equal
* to the end of the other.  With opposing or reverse cardinality it is possible for the start of
* both datums to match or the end of both datums to match.
*****************************************************************************************************/

      IF (l1_slk + l1_length) = l2_slk
         AND ((l1_start = l2_end)
             OR (l2_start = l1_end)
             OR (l1_start = l2_start)   --sscanlon fix 38036 19-SEP-2006
             OR (l1_end = l2_end)) THEN --sscanlon fix 38036 19-SEP-2006

                IF l2_type = 'S' THEN
                   IF l2_cardinal = 1 THEN
                      retval := nm_lref (l2_ne_id, 0);
                   ELSE
                      retval := nm_lref (l2_ne_id, l2_length);
                   END IF;
                ELSE
                  IF l1_cardinal = 1 THEN
                    retval := nm_lref( l1_ne_id, 0 );
                  ELSE
                    retval := nm_lref( l1_ne_id, l1_length );
                  END IF;
                END IF;

        RETURN retval;
      ELSE
        RAISE_APPLICATION_ERROR(-20002, 'Ambiguous linear reference');
      END IF;
    END IF;
  END IF;

  l_child_units := nm3net.get_nt_units( nm3net.get_nt_type( l1_ne_id ));

  IF l1_cardinal = 1 THEN

    l_offset := nm3unit.convert_unit( l_parent_units, l_child_units, p_parent_lr.lr_offset) - l1_slk + l1_begin_mp;    
    --dbms_output.put_line( 'offset = '||TO_CHAR( l_offset ));
    retval := nm_lref( l1_ne_id, l_offset );

  ELSE
    l_offset := l1_slk - nm3unit.convert_unit( l_parent_units, l_child_units, p_parent_lr.lr_offset ) + l1_end_mp;
    retval := nm_lref( l1_ne_id, l_offset);
  END IF;

  RETURN retval;
END;
--
-----------------------------------------------------------------------------
--
FUNCTION get_location_offset( p_parent_type IN varchar2, p_child_lref IN nm_lref ) RETURN nm_lref IS
CURSOR c1 IS
  SELECT get_set_offset( nm_ne_id_in, p_child_lref.lr_ne_id, p_child_lref.lr_offset), nm_ne_id_in
  FROM nm_members
   WHERE nm_ne_id_of = p_child_lref.lr_ne_id
   AND nm_obj_type = p_parent_type;

l_ne_id_in number;
l_offset   number;

BEGIN
  OPEN c1;
  FETCH c1 INTO l_offset, l_ne_id_in;
  IF c1%NOTFOUND THEN
    CLOSE c1;
    RAISE_APPLICATION_ERROR( -20001, 'Offset not available');
  END IF;
  CLOSE c1;
  RETURN nm_lref( l_ne_id_in, l_offset );
END;
--
-----------------------------------------------------------------------------
--
FUNCTION get_lref_ne_id( p_lref IN nm_lref ) RETURN number IS
retval number;
BEGIN
  retval := p_lref.lr_ne_id;
  RETURN retval;
END;
--
-----------------------------------------------------------------------------
--
FUNCTION get_lref_offset( p_lref IN nm_lref ) RETURN number IS
retval number;
BEGIN
  retval := p_lref.lr_offset;
  RETURN retval;
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_ambiguous_lrefs (p_parent_id    IN     number
                              ,p_parent_units IN     number
                              ,p_datum_units  IN     number
                              ,p_offset       IN     number
                              ,p_lrefs           OUT lref_table
                              ,p_sub_class    IN     varchar2 DEFAULT NULL
                              ,p_use_db       IN     varchar2 DEFAULT 'FALSE'
                              ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_ambiguous_lrefs');
--
   get_ambiguous_lrefs_internal (p_parent_id    => p_parent_id
                                ,p_parent_units => p_parent_units
                                ,p_datum_units  => p_datum_units
                                ,p_offset       => p_offset
                                ,p_lrefs        => p_lrefs
                                ,p_sub_class    => p_sub_class
                                ,p_use_true     => FALSE
                                ,p_use_db       => p_use_db
                                );
--
   nm_debug.proc_end(g_package_name,'get_ambiguous_lrefs');
--
END get_ambiguous_lrefs;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_ambiguous_lrefs_true (p_parent_id    IN     number
                                   ,p_parent_units IN     number
                                   ,p_datum_units  IN     number
                                   ,p_offset       IN     number
                                   ,p_lrefs           OUT lref_table
                                   ,p_sub_class    IN     varchar2 DEFAULT NULL
                                   ,p_use_db       IN     varchar2 DEFAULT 'FALSE'
                                   ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_ambiguous_lrefs_true');
--
   get_ambiguous_lrefs_internal (p_parent_id    => p_parent_id
                                ,p_parent_units => p_parent_units
                                ,p_datum_units  => p_datum_units
                                ,p_offset       => p_offset
                                ,p_lrefs        => p_lrefs
                                ,p_sub_class    => p_sub_class
                                ,p_use_true     => TRUE
                                ,p_use_db       => p_use_db
                                );
--
   nm_debug.proc_end(g_package_name,'get_ambiguous_lrefs_true');
--
END get_ambiguous_lrefs_true;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_ambiguous_lrefs_internal (p_parent_id    IN     number
                                       ,p_parent_units IN     number
                                       ,p_datum_units  IN     number
                                       ,p_offset       IN     number
                                       ,p_lrefs           OUT lref_table
                                       ,p_sub_class    IN     varchar2 DEFAULT NULL
                                       ,p_use_true     IN     boolean
                                       ,p_use_db       IN     varchar2
                                       ) IS
--
  CURSOR get_ambiguous_offsets_slk  (c_parent_id    number
                                    ,c_parent_units number
                                    ,c_datum_units  number
                                    ,c_offset       number
                                    ,c_sub_class    varchar2
                                    ,c_use_db       varchar2
                                    ) IS

  SELECT nm_ne_id_of
        ,nm_begin_mp
	,nm_end_mp
        ,nm_cardinality
        ,ne_no_start
        ,ne_no_end
        ,ne_nt_type
        ,ne_sub_class
        ,nm_slk
  FROM nm_members, nm_elements
  WHERE nm_ne_id_in = c_parent_id
  AND   decode( c_use_db, 'FALSE', 'D', nm3type.c_nvl ) != ne_type
  AND   nm_ne_id_of = ne_id
   AND   c_offset BETWEEN nm_slk AND nm_end_slk
  ORDER BY DECODE(c_sub_class, NULL, 'A', ne_sub_class, 'A',
                     nm3rvrs.reverse_sub_class( ne_nt_type, ne_sub_class, 'N'), 'C', 'B' ), nm_slk;
--
  CURSOR get_ambiguous_offsets_true (c_parent_id    number
                                    ,c_parent_units number
                                    ,c_datum_units  number
                                    ,c_offset       number
                                    ,c_sub_class    varchar2
                                    ,c_use_db       varchar2
                                    ) IS

  SELECT nm_ne_id_of
        ,nm_begin_mp
	,nm_end_mp
        ,nm_cardinality
        ,ne_no_start
        ,ne_no_end
        ,ne_nt_type
        ,ne_sub_class
        ,nm_true
  FROM nm_members, nm_elements
  WHERE nm_ne_id_in = c_parent_id
  AND   decode( c_use_db, 'FALSE', 'D', nm3type.c_nvl ) != ne_type
  AND   nm_ne_id_of = ne_id
  AND   c_offset BETWEEN nm_true AND nm_end_true
  ORDER BY DECODE(c_sub_class, NULL, 'A', ne_sub_class, 'A',
                     nm3rvrs.reverse_sub_class( ne_nt_type, ne_sub_class, 'N'), 'C', 'B' ), nm_true;
--
   l_tab_nm_ne_id_of      nm3type.tab_number;
   l_tab_nm_begin_mp      nm3type.tab_number;
   l_tab_nm_end_mp        nm3type.tab_number;
   l_tab_nm_cardinality   nm3type.tab_number;
   l_tab_ne_no_start      nm3type.tab_number;
   l_tab_ne_no_end        nm3type.tab_number;
   l_tab_ne_nt_type       nm3type.tab_varchar4;
   l_tab_ne_sub_class     nm3type.tab_varchar4;
   l_tab_nm_slk           nm3type.tab_number;
--
  lref_index binary_integer := 0;
--
   l_slk number;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_ambiguous_lrefs_internal');
--
   IF p_use_true
    THEN
      OPEN  get_ambiguous_offsets_true (p_parent_id, p_parent_units, p_datum_units, p_offset, p_sub_class, p_use_db);
      FETCH get_ambiguous_offsets_true
       BULK COLLECT
       INTO l_tab_nm_ne_id_of
           ,l_tab_nm_begin_mp
           ,l_tab_nm_end_mp
           ,l_tab_nm_cardinality
           ,l_tab_ne_no_start
           ,l_tab_ne_no_end
           ,l_tab_ne_nt_type
           ,l_tab_ne_sub_class
           ,l_tab_nm_slk;
      CLOSE get_ambiguous_offsets_true;
   ELSE
      OPEN  get_ambiguous_offsets_slk (p_parent_id, p_parent_units, p_datum_units, p_offset, p_sub_class, p_use_db);
      FETCH get_ambiguous_offsets_slk
       BULK COLLECT
       INTO l_tab_nm_ne_id_of
           ,l_tab_nm_begin_mp
           ,l_tab_nm_end_mp
           ,l_tab_nm_cardinality
           ,l_tab_ne_no_start
           ,l_tab_ne_no_end
           ,l_tab_ne_nt_type
           ,l_tab_ne_sub_class
           ,l_tab_nm_slk;
      CLOSE get_ambiguous_offsets_slk;
   END IF;
--
  FOR i IN 1..l_tab_nm_ne_id_of.COUNT
   LOOP
     IF p_sub_class IS NOT NULL
      AND i > 1
      AND l_tab_ne_sub_class(i) = nm3rvrs.reverse_sub_class( l_tab_ne_nt_type(i), p_sub_class, 'N')
     THEN
       --either we have already processed the specified sub class (it is ordered first)
       --or there are no lrefs in the specified sub class.
       --either way, exit the loop.
       EXIT;
     END IF;
     --
     --l_slk := nm3unit.convert_unit(p_parent_units, p_datum_units, l_tab_nm_slk(i));
     lref_index := lref_index + 1;
     p_lrefs( lref_index ).r_ne_id  := l_tab_nm_ne_id_of(i);
     IF l_tab_nm_cardinality(i) = 1 THEN
       p_lrefs( lref_index).r_offset :=
	        nm3unit.convert_unit( p_parent_units, p_datum_units, (p_offset - l_tab_nm_slk(i)))   + l_tab_nm_begin_mp(i) ;
     ELSE
       p_lrefs( lref_index ).r_offset :=
	        l_tab_nm_end_mp(i) - (nm3unit.convert_unit( p_parent_units, p_datum_units, (p_offset-l_tab_nm_slk(i))));
     END IF;
  END LOOP;

  IF lref_index = 0
  THEN
    hig.raise_ner (pi_appl               => nm3type.c_net
                  ,pi_id                 => 85
                  ,pi_sqlcode            => -20015
                  ,pi_supplementary_info => nm3net.get_ne_unique(p_parent_id)||' : '||p_offset
                  );
--    RAISE_APPLICATION_ERROR(-20015, 'No datum sections at this linear reference');
  END IF;
--
   nm_debug.proc_end(g_package_name,'get_ambiguous_lrefs_internal');
--
END get_ambiguous_lrefs_internal;
--
-----------------------------------------------------------------------------
--
FUNCTION get_relative_reference( p_parent_type IN nm_members_all.nm_type%TYPE,
                                 p_parent_obj  IN nm_members_all.nm_obj_type%TYPE,
   						         p_child_lref  IN nm_lref,
								 p_xsp         IN nm_xsp.nwx_x_sect%TYPE ) RETURN nm_lref IS

CURSOR ci( c_obj_type nm_members_all.nm_obj_type%TYPE,
           c_ne_id    nm_members_all.nm_ne_id_of%TYPE,
		   c_offset   nm_members_all.nm_begin_mp%TYPE,
		   c_xsp      nm_xsp.nwx_x_sect%TYPE )  IS
 SELECT nm_ne_id_in, nm_begin_mp
 FROM  nm_members, nm_inv_items
 WHERE nm_ne_id_of = c_ne_id
 AND nm_begin_mp <= c_offset
 AND NVL(nm_end_mp, c_offset+1) >= c_offset
 AND nm_obj_type = c_obj_type
 AND nm_ne_id_in = iit_ne_id
 AND DECODE( c_xsp, NULL, '$$$$', NVL(iit_x_sect,'$$$$'))  = NVL(c_xsp, '$$$$')
 ORDER BY nm_begin_mp;

 CURSOR cg( c_obj_type nm_members_all.nm_obj_type%TYPE,
           c_ne_id    nm_members_all.nm_ne_id_of%TYPE,
		   c_offset   nm_members_all.nm_begin_mp%TYPE ) IS
 SELECT nm_ne_id_in, nm_slk, nm_begin_mp, nm_end_mp
 FROM nm_members
 WHERE nm_ne_id_of = c_ne_id
 AND  nm_ne_id_in = Nvl(nm3net.g_dyn_ne_id,nm_ne_id_in) -- --Log 719614 :Linesh:18-MAr-2009:Pick the correct Route
 AND nm_begin_mp <= c_offset
 AND NVL(nm_end_mp, c_offset+1) >= c_offset
 AND nm_obj_type = c_obj_type
 ORDER BY nm_begin_mp;

 l_ne_id_in  nm_members_all.nm_ne_id_in%TYPE;
 l_begin_mp  nm_members_all.nm_begin_mp%TYPE;
 l_end_mp    nm_members_all.nm_end_mp%TYPE;
 l_slk       nm_members_all.nm_slk%TYPE;
 l_offset    nm_members_all.nm_begin_mp%TYPE := p_child_lref.lr_offset;
 l_ne_id_of  nm_members_all.nm_ne_id_of%TYPE := p_child_lref.lr_ne_id;
BEGIN

  IF p_parent_type = 'I' THEN
    OPEN ci( p_parent_obj, l_ne_id_of, l_offset, p_xsp );
	FETCH ci INTO l_ne_id_in, l_begin_mp;
	IF ci%NOTFOUND THEN
	  CLOSE ci;
	  RAISE_APPLICATION_ERROR( -20001, 'Relative Reference not found' );
    END IF;
	CLOSE ci;

	RETURN nm_lref( l_ne_id_in, l_offset - l_begin_mp );

  ELSE

    OPEN cg( p_parent_obj, l_ne_id_of, l_offset);
	FETCH cg INTO l_ne_id_in, l_slk, l_begin_mp, l_end_mp;
	IF cg%NOTFOUND THEN
	  CLOSE cg;
	  RAISE_APPLICATION_ERROR( -20002, 'Relative Group Reference not found' );
    END IF;
	CLOSE cg;


	IF nm3net.is_nt_linear( nm3net.get_nt_type( l_ne_id_in )) = 'Y' THEN

	  RETURN nm_lref( l_ne_id_in, get_set_offset( l_ne_id_in, l_ne_id_of, l_offset - l_begin_mp ));

	ELSE

	  RETURN nm_lref( l_ne_id_in, l_offset - l_begin_mp );

	END IF;

  END IF;


END;
--
-----------------------------------------------------------------------------
--
FUNCTION get_datum_true_offset (pi_ne_id     IN nm_elements.ne_id%TYPE
                               ,pi_true      IN nm_members.nm_true%TYPE
                               ,pi_sub_class IN nm_elements.ne_sub_class%TYPE
                               ) RETURN nm_lref IS

p_parent_lr nm_lref := nm_lref( pi_ne_id, pi_true );

l_nt_type nm_types.nt_type%TYPE := nm3net.get_nt_type( p_parent_lr.lr_ne_id );
l_parent_units number           := nm3net.get_nt_units(l_nt_type);

l_child_units  number;
l_offset       number;

CURSOR c1 ( c_parent_units number, c_offset number, c_ne_id number ) IS
  SELECT nm_ne_id_of, nm_cardinality, nm_true,
         nm_begin_mp, nm_end_mp,
         ne_length
  FROM nm_members, nm_elements
  WHERE nm_ne_id_in = c_ne_id
  AND   nm_ne_id_of = ne_id
  AND   c_offset BETWEEN nm_true AND nm_end_true
  AND   Nvl(ne_sub_class,'$') = Nvl(pi_sub_class,Nvl(ne_sub_class,'$')); -- Task 0109869 added this code to filter the data if subclas is passed
        --nm_slk + nm3unit.convert_unit( nm3net.get_nt_units( nm3net.get_nt_type( ne_id )), c_parent_units, ne_length );

l1_slk         number;
l1_ne_id       number;
l1_cardinal    number;
l1_length      number;
l1_nm_begin    number;
l1_nm_end      number;

l2_slk         number;
l2_ne_id       number;
l2_cardinal    number;
l2_length      number;
l2_nm_begin    number;
l2_nm_end      number;

retval         nm_lref;

BEGIN

  OPEN c1( l_parent_units, p_parent_lr.lr_offset, p_parent_lr.lr_ne_id);
  FETCH c1 INTO l1_ne_id, l1_cardinal, l1_slk, l1_nm_begin, l1_nm_end, l1_length;

  --dbms_output.put_line( 'Id = '||TO_CHAR( l1_ne_id )||' Offset = '||TO_CHAR( l1_slk ));

  IF c1%NOTFOUND THEN
    CLOSE c1;
    RAISE_APPLICATION_ERROR(-20001, 'No translation for linear reference');
  ELSE
    FETCH c1 INTO l2_ne_id, l2_cardinal, l2_slk, l2_nm_begin, l2_nm_end, l2_length;
    IF c1%NOTFOUND THEN
      CLOSE c1;
    ELSE
      CLOSE c1;
      RAISE_APPLICATION_ERROR(-20002, 'Ambiguous linear reference');
    END IF;
  END IF;

  l_child_units := nm3net.get_nt_units( nm3net.get_nt_type( l1_ne_id ));

  IF l1_cardinal = 1 THEN

    l_offset := nm3unit.convert_unit( l_parent_units, l_child_units, p_parent_lr.lr_offset - l1_slk) + l1_nm_begin;
    --dbms_output.put_line( 'offset = '||TO_CHAR( l_offset ));
    retval := nm_lref( l1_ne_id, l_offset );

  ELSE
    l_offset := NVL( l1_nm_end, l1_length) - nm3unit.convert_unit( l_parent_units, l_child_units, p_parent_lr.lr_offset - l1_slk );
    retval := nm_lref( l1_ne_id, l_offset);
  END IF;

  RETURN retval;
END;
--

--
-----------------------------------------------------------------------------
--
FUNCTION get_datum_mp_from_route_true (pi_ne_id     IN nm_elements.ne_id%TYPE
                                      ,pi_true      IN nm_members.nm_true%TYPE
                                      ,pi_sub_class IN nm_elements.ne_sub_class%TYPE
                                      ) RETURN nm_lref IS
--
   retval         nm_lref;
--
   l_p_unit number;
   l_c_unit number;
--
BEGIN
--
   nm3net.get_group_units( pi_ne_id, l_p_unit, l_c_unit );
--
   retval := get_datum_true_offset (pi_ne_id
                                   ,pi_true
                                   ,pi_sub_class
                                   );

--   retval.lr_offset := nm3unit.convert_unit(l_p_unit,l_c_unit,retval.lr_offset);
   RETURN retval;
--
END get_datum_mp_from_route_true;
--
-----------------------------------------------------------------------------
--
PROCEDURE mid_block_data( route_id        IN number
                        , node1           IN number
                        , node2           IN number
                        , sub_class       IN varchar2
                        , distance_error OUT number
                        , ne_id          OUT number
                        , offset         OUT number
                        )
IS
--
CURSOR c1( c_p_unit number, c_c_unit number ) IS
  SELECT m1.nm_ne_id_of, m1.nm_true,
    (m2.nm_true + nm3unit.convert_unit(c_c_unit,c_p_unit,nm3net.get_datum_element_length( m2.nm_ne_id_of )) - m1.nm_true)/2
  FROM nm_members m1, nm_members m2, nm_node_usages n1, nm_node_usages n2,
       nm_elements e1, nm_elements e2
  WHERE m1.nm_ne_id_in = route_id
  AND   m2.nm_ne_id_in = route_id
  AND   n1.nnu_no_node_id = node1
  AND   n2.nnu_no_node_id = node2
  AND   n1.nnu_ne_id = m1.nm_ne_id_of
  AND   n2.nnu_ne_id = m2.nm_ne_id_of
  AND   m1.nm_ne_id_of = e1.ne_id
  AND   m2.nm_ne_id_of = e2.ne_id
  AND   e1.ne_sub_class = NVL( sub_class, e1.ne_sub_class )
  AND   e2.ne_sub_class = NVL( sub_class, e2.ne_sub_class )
  AND   n1.nnu_node_type = 'S'
  AND   n2.nnu_node_type = 'E';
--
l_offset number;
l_true   number;
l_ne_id  number;
l_d_err  number;
--
l_lref   nm_lref;
--
l_p_unit number;
l_c_unit number;
--
BEGIN
  nm3net.get_group_units( route_id, l_p_unit, l_c_unit );
--
  OPEN c1( l_p_unit, l_c_unit);
  FETCH c1 INTO l_ne_id, l_true, l_d_err;
  IF c1%NOTFOUND THEN
    CLOSE c1;
    RAISE_APPLICATION_ERROR( -20001, 'No distance error found - check the nodes' );
  END IF;
  CLOSE c1;
--
-- add the d-err to the position on the network of the element.
--
  l_offset := l_true + l_d_err;
--
  l_lref   := nm3lrs.get_datum_true_offset( route_id, l_offset, sub_class );
--
  ne_id    := nm3lrs.get_lref_ne_id( l_lref );
--
-- This is the offset along the element ie chainage.
  offset := nm3lrs.get_lref_offset( l_lref );
--
  distance_error := l_d_err;
END mid_block_data;
--
-----------------------------------------------------------------------------
--
FUNCTION unique_sub_class( p_route_id IN number,
                                             pi_st_true IN number,
					     pi_end_true IN number) RETURN boolean IS

CURSOR c1 IS
  SELECT 1
  FROM dual
  WHERE EXISTS ( SELECT 1
                 FROM nm_elements am, nm_elements bm, nm_members ar, nm_members br
                 WHERE ar.nm_ne_id_in = p_route_id
                 AND   br.nm_ne_id_in = p_route_id
                 AND   am.ne_id = ar.nm_ne_id_of
                 AND   bm.ne_id = br.nm_ne_id_of
                 AND   bm.ne_sub_class != am.ne_sub_class
                 AND   ar.nm_true BETWEEN pi_st_true AND pi_end_true
                 AND   br.nm_true BETWEEN pi_st_true AND pi_end_true );

  l_found number;
  retval boolean;
BEGIN
  OPEN c1;
  FETCH c1 INTO l_found;
  retval := c1%NOTFOUND;
  CLOSE c1;
  RETURN retval;
END;
--
-----------------------------------------------------------------------------
--
FUNCTION max_seg_true ( p_route_id IN number, p_seg_no IN number ) RETURN number IS

CURSOR c1 IS
  SELECT MAX( nm_true )
  FROM nm_members
  WHERE nm_ne_id_in = p_route_id
  AND   nm_seg_no = p_seg_no;

retval number;

BEGIN
  OPEN c1;
  FETCH c1 INTO retval;
  CLOSE c1;
  RETURN retval;
END;
--
-----------------------------------------------------------------------------
--
FUNCTION min_seg_true ( p_route_id IN number, p_seg_no IN number ) RETURN number IS

CURSOR c1 IS
  SELECT MIN( nm_true )
  FROM nm_members
  WHERE nm_ne_id_in = p_route_id
  AND   nm_seg_no = p_seg_no;

retval number;

BEGIN
  OPEN c1;
  FETCH c1 INTO retval;
  CLOSE c1;
  RETURN retval;
END;
--
----------------------------------------------------------------------------------
--
FUNCTION get_block_reference(pi_route        IN nm_elements.ne_id%TYPE
                            ,pi_intersection IN nm_nodes.no_node_id%TYPE
                            ,pi_sub_class    IN nm_elements.ne_sub_class%TYPE DEFAULT NULL
                            ,pi_type         IN nm_nodes.no_node_type%TYPE
                            ) RETURN nm_lref IS

  l_nvl_1 CONSTANT varchar2(4) := '÷$÷$';
  l_nvl_2 CONSTANT varchar2(4) := '^$^$';

  CURSOR c1(p_route        IN nm_elements.ne_id%TYPE
           ,p_intersection IN nm_nodes.no_node_id%TYPE
           ,p_sub_class    IN nm_elements.ne_sub_class%TYPE
           ,p_type         IN nm_nodes.no_node_type%TYPE
           ,p_nvl_1        IN varchar2
           ,p_nvl_2        IN varchar2
           )IS
    SELECT
      nnu.nnu_ne_id,
      nnu.nnu_chain
    FROM
      nm_node_usages nnu,
      nm_elements    ne,
      nm_members     nm
    WHERE
      nm.nm_ne_id_in = p_route
    AND
      nm.nm_ne_id_of = nnu.nnu_ne_id
    AND
      nnu.nnu_no_node_id = p_intersection
    AND
      nnu_node_type = p_type
    AND
      ne.ne_id = nm.nm_ne_id_of
    AND
      NVL(ne.ne_sub_class, p_nvl_1) <> NVL(p_sub_class, p_nvl_2);

  l_dummy c1%ROWTYPE;

  l_rvs_sub_class nm_elements.ne_sub_class%TYPE;

  l_lref nm_lref := nm_lref(NULL, NULL);

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_block_reference');

  --get the opposite sub class
  IF pi_sub_class IS NOT NULL AND pi_sub_class <> 'S'
  THEN
    l_rvs_sub_class := nm3rvrs.reverse_sub_class(pi_nt_type    => nm3net.get_datum_nt(pi_ne_id => pi_route)
                                                ,pi_sub_class  => pi_sub_class
                                                ,pi_error_flag => 'Y');
  ELSE
    l_rvs_sub_class := NULL;
  END IF;

  --find sections on route at intersection
  OPEN c1(p_route        => pi_route
         ,p_intersection => pi_intersection
         ,p_sub_class    => l_rvs_sub_class
         ,p_type         => pi_type
         ,p_nvl_1        => l_nvl_1
         ,p_nvl_2        => l_nvl_2);

    FETCH c1 INTO l_lref.lr_ne_id, l_lref.lr_offset;

    IF c1%NOTFOUND
    THEN
      CLOSE c1;
      g_lrs_exc_code := -20031;
      g_lrs_exc_msg  :=    'Intersection ' || pi_intersection
                        || ' is not on route ' || pi_route || '.';
      RAISE g_lrs_exception;

    ELSE
      FETCH c1 INTO l_dummy;

      IF c1%FOUND
      THEN
        --too many rows,
        CLOSE c1;
        IF pi_sub_class IS NULL
        THEN
          --sub class should be specified
          g_lrs_exc_code := -20032;
          g_lrs_exc_msg  := 'Section not uniquely identified, specify a sub class.';
        ELSE
          --sub class already specified, network integrity compromised
          g_lrs_exc_code := -20033;
          g_lrs_exc_msg  := 'More than one section at this intersection with sub class ' || pi_sub_class || '.';
        END IF;
        RAISE g_lrs_exception;
      END IF;
    END IF;
  CLOSE c1;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_block_reference');

  RETURN l_lref;

EXCEPTION
  WHEN g_lrs_exception
  THEN
    RAISE_APPLICATION_ERROR(g_lrs_exc_code, g_lrs_exc_msg);

END get_block_reference;
--
----------------------------------------------------------------------------------
--
PROCEDURE check_relative_start_end(pi_route      IN nm_elements.ne_id%TYPE
                                  ,pi_start_lref IN nm_lref
                                  ,pi_end_lref   IN nm_lref
                                  ) IS

	e_cont_start_equals_end EXCEPTION;
	e_start_after_end EXCEPTION;

  l_parent_units nm_units.un_unit_id%TYPE;
  l_child_units nm_units.un_unit_id%TYPE;

  l_start_true number;
  l_end_true number;

  l_start_mem nm_members%ROWTYPE;
  l_end_mem   nm_members%ROWTYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'check_relative_start_end');
  DECLARE
    e_not_a_group EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_not_a_group, -20001);

    l_lr_offset number;
  BEGIN

    l_start_mem := get_nm_row( pi_route, pi_start_lref.lr_ne_id, pi_start_lref.lr_offset);
    l_end_mem   := get_nm_row( pi_route, pi_end_lref.lr_ne_id,   pi_end_lref.lr_offset);

    nm3net.get_group_units(pi_ne_id       => pi_route
                          ,po_group_units => l_parent_units
                          ,po_child_units => l_child_units);

    nm_debug.DEBUG( 'start - units = '||TO_CHAR(l_parent_units )||' '||TO_CHAR( l_child_units ));

    IF l_start_mem.nm_cardinality > 0
    THEN
      l_lr_offset := pi_start_lref.lr_offset - l_start_mem.nm_begin_mp;
--
    ELSE
      l_lr_offset := l_start_mem.nm_end_mp - pi_start_lref.lr_offset;
    END IF;


    l_start_true := l_start_mem.nm_true  + nm3unit.convert_unit(p_un_id_in  => l_child_units
                                                               ,p_un_id_out => l_parent_units
                                                               ,p_value     => l_lr_offset);

    IF l_end_mem.nm_cardinality > 0
    THEN
      l_lr_offset := pi_end_lref.lr_offset - l_end_mem.nm_begin_mp;
--
    ELSE
      l_lr_offset := l_end_mem.nm_end_mp - pi_end_lref.lr_offset;
    END IF;

    l_end_true := l_end_mem.nm_true + nm3unit.convert_unit(p_un_id_in  => l_child_units
                                                          ,p_un_id_out => l_parent_units
                                                          ,p_value     => l_lr_offset);

  EXCEPTION
    WHEN e_not_a_group
    THEN
      l_start_true := pi_start_lref.lr_offset;
      l_end_true   := pi_end_lref.lr_offset;
  END;

  IF l_start_true = l_end_true
  THEN
    g_lrs_exc_code := -20470;
    g_lrs_exc_msg  := 'Start is the same as end';
    RAISE g_lrs_exception;

  ELSIF l_start_true > l_end_true
  THEN
    g_lrs_exc_code := -20041;
    g_lrs_exc_msg  := 'Start is after end along route';
    RAISE g_lrs_exception;
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'check_relative_start_end');
EXCEPTION
  WHEN g_lrs_exception
  THEN
    RAISE_APPLICATION_ERROR(g_lrs_exc_code, g_lrs_exc_msg);

END check_relative_start_end;
--
----------------------------------------------------------------------------------
--
PROCEDURE process_lref_tab_excl_subclass(pio_lref_tab IN OUT lref_table
                                        ,pi_sub_class IN     nm_elements.ne_sub_class%TYPE
                                        ) IS

  l_lref_tab lref_table;

  l_new_i pls_integer := 0;

BEGIN
  FOR l_i IN 1..pio_lref_tab.COUNT
  LOOP
    IF nm3net.get_sub_class(pio_lref_tab(l_i).r_ne_id) = pi_sub_class
    THEN
      --put only elements with the correct sub class into new table
      l_new_i := l_new_i + 1;

      l_lref_tab(l_new_i) := pio_lref_tab(l_i);
    END IF;
  END LOOP;

  pio_lref_tab := l_lref_tab;

END process_lref_tab_excl_subclass;
--
----------------------------------------------------------------------------------
--
FUNCTION get_element_node_slk (p_route_ne_id    nm_elements.ne_id%TYPE
                              ,p_element_ne_id  nm_elements.ne_id%TYPE
                              ,p_node_type      nm_node_usages.nnu_node_type%TYPE
                              ,p_datum_length   nm_elements.ne_length%TYPE
                              ) RETURN nm_members.nm_slk%TYPE IS
--
   CURSOR cs_nm (c_ne_id_in nm_members.nm_ne_id_in%TYPE
                ,c_ne_id_of nm_members.nm_ne_id_of%TYPE
                ) IS
   SELECT *
    FROM  nm_members
   WHERE  nm_ne_id_in = c_ne_id_in
    AND   nm_ne_id_of = c_ne_id_of;
--
   l_rec_nm   nm_members%ROWTYPE;
   l_retval   number;
   l_c_unit   number;
   l_p_unit   number;
   l_slk_diff number;
--
BEGIN
--
   OPEN  cs_nm (p_route_ne_id, p_element_ne_id);
   FETCH cs_nm INTO l_rec_nm;
   IF cs_nm%NOTFOUND
    THEN
      CLOSE cs_nm;
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'NM_MEMBERS : '||p_route_ne_id||' : '||p_element_ne_id
                    );
   END IF;
   CLOSE cs_nm;
--
   IF nm3net.route_direction(p_node_type,l_rec_nm.nm_cardinality) > 0
    THEN
      l_retval := l_rec_nm.nm_slk;
   ELSE
      l_p_unit   := nm3net.get_gty_units(nm3net.get_gty_type(p_route_ne_id));
      l_c_unit   := nm3net.get_nt_units(nm3net.get_ne(p_element_ne_id).ne_nt_type);
      l_slk_diff := nm3unit.convert_unit( l_c_unit, l_p_unit, p_datum_length );
      l_retval   := l_rec_nm.nm_slk + l_slk_diff;
   END IF;
--
   RETURN l_retval;
--
END get_element_node_slk;
--
----------------------------------------------------------------------------------
--
FUNCTION get_tab_lref (p_ne_id  nm_elements.ne_id%TYPE
                      ,p_offset nm_members.nm_begin_mp%TYPE
                      ) RETURN lref_table IS
--
   CURSOR cs_lref (c_ne_id nm_members.nm_ne_id_of%TYPE
                  ,c_mp    nm_members.nm_begin_mp%TYPE
                  ) IS
   SELECT nm_ne_id_in
         ,nm3lrs.get_set_offset(nm_ne_id_in, nm_ne_id_of, c_mp)
         ,nm_type
         ,nm_obj_type
    FROM  vnm_linear_types
         ,nm_members
         ,nm_elements
   WHERE  nm_ne_id_of = c_ne_id
    AND   nlt_g_or_i  = nm_type
    AND   nlt_type    = nm_obj_type
    AND   nm_ne_id_of = ne_id
    AND   c_mp BETWEEN nm_begin_mp AND NVL(nm_end_mp,ne_length);
--
   CURSOR cs_is_linear (c_ne_id nm_members.nm_ne_id_in%TYPE
                       ) IS
   SELECT nlt_units
    FROM  vnm_linear_types
         ,nm_members
   WHERE  nm_ne_id_in = c_ne_id
    AND   nlt_g_or_i  = nm_type
    AND   nlt_type    = nm_obj_type;
--
   l_tab_ne_id       nm3type.tab_number;
   l_tab_offset      nm3type.tab_number;
   l_tab_nm_type     nm3type.tab_varchar4;
   l_tab_nm_obj_type nm3type.tab_varchar4;
--
   l_lref_table      lref_table;
   l_lref_record     lref_record;
   l_lref_tab        lref_table;
   l_count           pls_integer := 0;
--
   l_lref            nm_lref;
--
   l_dummy           pls_integer;
   l_nlt_units       vnm_linear_types.nlt_units%TYPE;
   l_is_linear       boolean;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_tab_lref');
--
   DECLARE
      no_lref EXCEPTION;
   BEGIN
      OPEN  cs_is_linear (p_ne_id);
      FETCH cs_is_linear INTO l_nlt_units;
      l_is_linear := cs_is_linear%FOUND;
      CLOSE cs_is_linear;
   --
      l_lref_record.r_source := 'E';
      IF l_is_linear
       THEN
         DECLARE
            l_no_lref EXCEPTION;
            PRAGMA EXCEPTION_INIT (l_no_lref,  -20001);
            l_ambiguous EXCEPTION;
            PRAGMA EXCEPTION_INIT (l_ambiguous,-20002);
            l_parent_units nm_units.un_unit_id%TYPE;
            l_child_units  nm_units.un_unit_id%TYPE;
         BEGIN
            l_lref                 := get_datum_offset (nm_lref(p_ne_id, p_offset));
            l_lref_record.r_ne_id  := l_lref.get_ne_id;
            l_lref_record.r_offset := l_lref.get_offset;
            l_count                := l_count + 1;
            l_lref_table(l_count)  := l_lref_record;
            l_lref_tab(1)          := l_lref_record;
         EXCEPTION
            WHEN l_no_lref
             THEN
               RAISE no_lref;
            WHEN l_ambiguous
             THEN
               nm3net.get_group_units (pi_ne_id       => p_ne_id
                                      ,po_group_units => l_parent_units
                                      ,po_child_units => l_child_units
                                      );
               get_ambiguous_lrefs    (p_parent_id    => p_ne_id
                                      ,p_parent_units => l_nlt_units
                                      ,p_datum_units  => l_child_units
                                      ,p_offset       => p_offset
                                      ,p_lrefs        => l_lref_tab
                                      );
               FOR i IN 1..l_lref_tab.COUNT
                LOOP
                  l_lref_record          := l_lref_tab(i);
                  l_lref_record.r_source := 'E';
                  l_count                := l_count + 1;
                  l_lref_table(l_count)  := l_lref_record;
               END LOOP;
         END;
      ELSE
         l_lref_record.r_ne_id  := p_ne_id;
         l_lref_record.r_offset := p_offset;
         l_count                := l_count + 1;
         l_lref_table(l_count)  := l_lref_record;
         l_lref_tab(1)          := l_lref_record;
      END IF;
   --
      FOR i IN 1..l_lref_tab.COUNT
       LOOP
         OPEN  cs_lref (l_lref_tab(i).r_ne_id, l_lref_tab(i).r_offset);
         FETCH cs_lref
          BULK COLLECT
          INTO l_tab_ne_id
              ,l_tab_offset
              ,l_tab_nm_type
              ,l_tab_nm_obj_type;
         CLOSE cs_lref;
      --
         FOR i IN 1..l_tab_ne_id.COUNT
          LOOP
            --
            l_lref_record.r_ne_id       := l_tab_ne_id(i);
            l_lref_record.r_offset      := l_tab_offset(i);
            IF l_tab_nm_type(i) = 'I'
             THEN
               l_lref_record.r_source := l_tab_nm_type(i);
            ELSE
               l_lref_record.r_source := 'E';
            END IF;
            --
            l_count                := l_count + 1;
            l_lref_table(l_count)  := l_lref_record;
            --
         END LOOP;
      END LOOP;
   EXCEPTION
      WHEN no_lref
       THEN
         NULL;
   END;
--
   nm_debug.proc_end(g_package_name,'get_tab_lref');
--
--   FOR i IN 1..l_count
--    LOOP
--      l_lref_record := l_lref_table(i);
--      nm_debug.debug(l_lref_record.r_ne_id||':'||l_lref_record.r_offset||':'||l_lref_record.r_source);
--   END LOOP;
--
   RETURN l_lref_table;
--
END get_tab_lref;
--
----------------------------------------------------------------------------------
--
FUNCTION get_nlt (p_nlt_type   vnm_linear_types.nlt_type%TYPE
                 ,p_nlt_g_or_i vnm_linear_types.nlt_g_or_i%TYPE
                 ) RETURN vnm_linear_types%ROWTYPE IS
--
   CURSOR cs_nlt (c_nlt_type   vnm_linear_types.nlt_type%TYPE
                 ,c_nlt_g_or_i vnm_linear_types.nlt_g_or_i%TYPE
                 ) IS
   SELECT *
    FROM  vnm_linear_types
   WHERE  nlt_type   = c_nlt_type
    AND   nlt_g_or_i = c_nlt_g_or_i;
--
   l_rec_nlt vnm_linear_types%ROWTYPE;
--
BEGIN
--
   OPEN  cs_nlt (p_nlt_type, p_nlt_g_or_i);
   FETCH cs_nlt INTO l_rec_nlt;
   CLOSE cs_nlt;
--
   RETURN l_rec_nlt;
--
END get_nlt;
--
----------------------------------------------------------------------------------
--
FUNCTION get_nm_row( p_nm_ne_id_in IN nm_elements.ne_id%TYPE,
                     p_nm_ne_id_of IN nm_elements.ne_id%TYPE,
                     p_nm_offset   IN nm_members.nm_begin_mp%TYPE ) RETURN nm_members%ROWTYPE IS

CURSOR c1( c_nm_ne_id_in IN nm_elements.ne_id%TYPE,
           c_nm_ne_id_of IN nm_elements.ne_id%TYPE,
           c_nm_offset   IN nm_members.nm_begin_mp%TYPE ) IS
  SELECT * FROM nm_members
  WHERE nm_ne_id_in = c_nm_ne_id_in
  AND   nm_ne_id_of = c_nm_ne_id_of
  AND   c_nm_offset BETWEEN nm_begin_mp AND nm_end_mp;

retval nm_members%ROWTYPE;

BEGIN
  OPEN c1( p_nm_ne_id_in, p_nm_ne_id_of, p_nm_offset );
  FETCH c1 INTO retval;
  CLOSE c1;
  RETURN retval;
  EXCEPTION
      WHEN no_data_found
       THEN -- No translation for linear reference
         hig.raise_ner (pi_appl    => nm3type.c_net
                       ,pi_id      => 85
                       ,pi_sqlcode => -20001
                       );
      WHEN too_many_rows
       THEN -- Ambiguous linear reference
         hig.raise_ner (pi_appl    => nm3type.c_net
                       ,pi_id      => 312
                       ,pi_sqlcode => -20002
                       );

END get_nm_row;
--
----------------------------------------------------------------------------------
--
FUNCTION get_coinciding_nodes_sql(pi_route_ne_id   IN nm_elements.ne_id%TYPE
                                 ,pi_offset        IN NUMBER) RETURN VARCHAR2 IS

 v_route_ne_rec  nm_elements%ROWTYPE := nm3net.get_ne(pi_route_ne_id);
 v_datum_nt      nm_types.nt_type%TYPE;
 v_datum_units   nm_types.nt_length_unit%TYPE;
 v_route_units   nm_types.nt_length_unit%TYPE;
 v_datum_min_length NUMBER;


BEGIN

  v_datum_nt         :=   nm3net.get_datum_nt(pi_gty => v_route_ne_rec.ne_gty_group_type);
  v_datum_units      :=   nm3net.get_nt_units(p_nt_type => v_datum_nt);
  v_route_units      :=   nm3net.get_nt_units(p_nt_type => v_route_ne_rec.ne_nt_type);
  v_datum_min_length :=   nm3net.get_min_element_length_allowed(pi_nt_type => v_datum_nt);

  RETURN( 'SELECT no_node_name, no_descr, no_node_id'||chr(10)
             ||'FROM nm_node_usages'||chr(10)
             ||'   , nm_members'||chr(10)
             ||'   , nm_nodes'||chr(10)
             ||'WHERE nnu_ne_id = nm_ne_id_of'||chr(10)
             ||'AND   nnu_no_node_id = no_node_id'||chr(10)
             ||'AND   nm_ne_id_in = '||TO_CHAR(pi_route_ne_id)||chr(10)
             ||'AND   nnu_chain = decode(nm_cardinality, -1, nm_end_mp,nm_begin_mp)'||chr(10)
             ||'AND   nm_slk + nm3unit.convert_unit('||TO_CHAR(v_datum_units)||',  --datum units'||chr(10)
             ||'                                  '||TO_CHAR(v_route_units)||',  --group units'||chr(10)
             ||'                                  nm_begin_mp ) between ('||TO_CHAR(pi_offset - v_datum_min_length)||' ) and ('||TO_CHAR(pi_offset + v_datum_min_length)||' )');

END get_coinciding_nodes_sql;
--
----------------------------------------------------------------------------------
--
FUNCTION get_coinciding_nodes(pi_route_ne_id   IN nm_elements.ne_id%TYPE
                             ,pi_offset        IN NUMBER) RETURN tab_rec_nodes IS

 v_ref_cur        nm3type.ref_cursor;
 v_tab_rec_nodes  tab_rec_nodes;

BEGIN

 OPEN v_ref_cur FOR get_coinciding_nodes_sql(pi_route_ne_id,pi_offset);
 FETCH v_ref_cur BULK COLLECT INTO v_tab_rec_nodes;
 CLOSE v_ref_cur;

 RETURN(v_tab_rec_nodes);

END get_coinciding_nodes;
--
----------------------------------------------------------------------------------
--
FUNCTION is_location_ambiguous(pi_ne_id     IN nm_elements.ne_id%TYPE
                              ,pi_offset    IN NUMBER
                              ,pi_sub_class IN varchar2 DEFAULT NULL) RETURN BOOLEAN IS

BEGIN


 	  nm3wrap.get_ambiguous_lrefs(pi_parent_id => pi_ne_id
                                 ,pi_offset    => nm3net.get_min_slk(pi_ne_id));

      IF nm3wrap.lref_count > 1 THEN
	     RETURN(TRUE);
	  ELSE
         RETURN(FALSE);
	  END IF;

END is_location_ambiguous;
--
----------------------------------------------------------------------------------
--
END;
/
