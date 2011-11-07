CREATE OR REPLACE PACKAGE BODY Nm3net AS
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3net.pkb-arc   2.8   Nov 07 2011 10:59:02   Rob.Coupe  $
--       Module Name      : $Workfile:   nm3net.pkb  $
--       Date into SCCS   : $Date:   Nov 07 2011 10:59:02  $
--       Date fetched Out : $Modtime:   Nov 07 2011 10:57:50  $
--       SCCS Version     : $Revision:   2.8  $
--       Based on 
--
--
--   Author : Rob Coupe
--
--     nm3net package
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2000
-----------------------------------------------------------------------------

-- 03.06.08 PT added pi_no_purpose parameter to create_node()
--              (create_or_reuse_point_and_node() also creates nodes, this sets null no_purpose)

--
   g_body_sccsid     CONSTANT  VARCHAR2(200) := '"$Revision:   2.8  $"';
--  g_body_sccsid is the SCCS ID for the package body
  g_package_name CONSTANT  VARCHAR2(30) := 'nm3net';
--
  g_block        Nm3type.max_varchar2;
--  
--
----------------------------------------------------------------------------------
--
PROCEDURE calculate_node_slk(pi_ne_id           IN     nm_elements.ne_id%TYPE
                            ,pi_type_new        IN     NM_TYPES.nt_type%TYPE
                            ,pi_type_old        IN     NM_TYPES.nt_type%TYPE
                            ,pi_slk_old         IN     nm_members.nm_slk%TYPE
                            ,pi_true_old        IN     nm_members.nm_true%TYPE
                            ,pi_cardinality_old IN     nm_members.nm_cardinality%TYPE
                            ,pi_length_new      IN     nm_elements.ne_length%TYPE
                            ,pi_length_old      IN     nm_elements.ne_length%TYPE
                            ,po_slk_new         IN OUT nm_members.nm_slk%TYPE
                            ,po_cardinality_new IN OUT nm_members.nm_cardinality%TYPE
                            ,po_true_new        IN OUT nm_members.nm_true%TYPE
                            );
--
-----------------------------------------------------------------------------
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
-----------------------------------------------------------------------------
--
FUNCTION get_next_ne_id RETURN NUMBER IS
BEGIN
  Nm_Debug.proc_start(g_package_name,'get_next_ne_id');
  Nm_Debug.proc_end(g_package_name,'get_next_ne_id');
  RETURN Nm3seq.next_ne_id_seq;
END get_next_ne_id;
--
-----------------------------------------------------------------------------
--
FUNCTION Get_Ne_Length( p_ne_id IN NUMBER ) RETURN NUMBER IS

   CURSOR cs_mem (c_ne_id_in NUMBER) IS
   SELECT SUM(nm_end_mp - nm_begin_mp)
    FROM  nm_members
   WHERE  nm_ne_id_in = c_ne_id_in;
--
  l_rec_ne nm_elements%ROWTYPE;
--
  l_retval NUMBER := NULL;
  l_get_bare_member_len BOOLEAN := FALSE;
--
BEGIN
--
  Nm_Debug.proc_start(g_package_name,'get_ne_length');
--
  l_rec_ne := Nm3get.get_ne (pi_ne_id           => p_ne_id
                            ,pi_raise_not_found => FALSE
                            );
--
  IF l_rec_ne.ne_id IS NOT NULL
   THEN
     IF l_rec_ne.ne_type IN ('S','D')
      THEN
        l_retval := l_rec_ne.ne_length;
     ELSE
        l_get_bare_member_len := TRUE;
     END IF;
  ELSE
     l_get_bare_member_len := TRUE;
  END IF;
--
  IF l_get_bare_member_len
   THEN
     OPEN  cs_mem (p_ne_id);
     FETCH cs_mem INTO l_retval;
     CLOSE cs_mem;
  END IF;
--
  Nm_Debug.proc_end(g_package_name,'get_ne_length');
  RETURN l_retval;
--
END Get_Ne_Length;
--
-----------------------------------------------------------------------------
--
FUNCTION get_datum_element_length (pi_ne_id IN NUMBER) RETURN NUMBER IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_datum_element_length');
   Nm_Debug.proc_end(g_package_name,'get_datum_element_length');
   RETURN Nm3get.get_ne_all(pi_ne_id           => pi_ne_id
                           ,pi_raise_not_found => FALSE
                           ).ne_length;
END get_datum_element_length;
--
-----------------------------------------------------------------------------
--
FUNCTION get_start_node( p_ne_id IN NUMBER) RETURN NUMBER IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_start_node');
   Nm_Debug.proc_end(g_package_name,'get_start_node');
   RETURN Nm3get.get_ne_all(pi_ne_id           => p_ne_id
                           ,pi_raise_not_found => FALSE
                           ).ne_no_start;
END get_start_node;
--
-----------------------------------------------------------------------------
--
FUNCTION get_start_node( p_ne_unique IN VARCHAR2) RETURN NUMBER IS
   l_ne_id nm_elements.ne_id%TYPE;
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_start_node');
   l_ne_id := get_ne_id (p_ne_unique => p_ne_unique);
   Nm_Debug.proc_end(g_package_name,'get_start_node');
   RETURN get_start_node(p_ne_id=>l_ne_id);
END get_start_node;
--
-----------------------------------------------------------------------------
--
FUNCTION get_end_node ( p_ne_id IN NUMBER)  RETURN NUMBER IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_end_node');
   Nm_Debug.proc_end(g_package_name,'get_end_node');
   RETURN Nm3get.get_ne_all(pi_ne_id           => p_ne_id
                           ,pi_raise_not_found => FALSE
                           ).ne_no_end;
END get_end_node;
--
-----------------------------------------------------------------------------
--
FUNCTION get_end_node ( p_ne_unique IN VARCHAR2)  RETURN NUMBER IS
   l_ne_id nm_elements.ne_id%TYPE;
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_end_node');
   l_ne_id := get_ne_id (p_ne_unique => p_ne_unique);
   Nm_Debug.proc_end(g_package_name,'get_end_node');
   RETURN get_end_node(p_ne_id=>l_ne_id);
END get_end_node;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ne_id(p_ne_unique  IN VARCHAR2
                  ,p_ne_nt_type IN nm_elements.ne_nt_type%TYPE DEFAULT NULL
                  ) RETURN NUMBER IS
--
   retval        nm_elements.ne_id%TYPE;
   l_nt_type     VARCHAR2(100);
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'get_ne_id');
--
   IF p_ne_nt_type IS NOT NULL
    THEN
      l_nt_type := ':'||p_ne_nt_type;
   END IF;
--
   SELECT ne_id
    INTO  retval
    FROM  nm_elements
   WHERE  ne_unique  = p_ne_unique
    AND   ne_nt_type = NVL(p_ne_nt_type,ne_nt_type);
--
   Nm_Debug.proc_end(g_package_name,'get_ne_id');
--
   RETURN retval;
--
EXCEPTION
   WHEN NO_DATA_FOUND
    THEN
      Hig.raise_ner (pi_appl               => Nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => -20001
                    ,pi_supplementary_info => 'nm_elements:'||p_ne_unique||l_nt_type
                    );
   WHEN TOO_MANY_ROWS
    THEN
      Hig.raise_ner (pi_appl               => Nm3type.c_net
                    ,pi_id                 => 284
                    ,pi_supplementary_info => p_ne_unique
                    );
END get_ne_id;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ne_unique( p_ne_id IN NUMBER )     RETURN  nm_elements.ne_unique%TYPE IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_ne_unique');
   Nm_Debug.proc_end(g_package_name,'get_ne_unique');
   RETURN Nm3get.get_ne_all(pi_ne_id             => p_ne_id
                           ,pi_not_found_sqlcode => -20002
                           ).ne_unique;
END get_ne_unique;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ne_descr( p_ne_id IN NUMBER )     RETURN VARCHAR2 IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_ne_descr');
   Nm_Debug.proc_end(g_package_name,'get_ne_descr');
   RETURN Nm3get.get_ne_all(pi_ne_id             => p_ne_id
                           ,pi_not_found_sqlcode => -20002
                           ).ne_descr;
END get_ne_descr;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ne_gty(pi_ne_id IN nm_elements.ne_id%TYPE
                   ) RETURN nm_elements.ne_gty_group_type%TYPE IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_ne_gty');
   Nm_Debug.proc_end(g_package_name,'get_ne_gty');
   RETURN Nm3get.get_ne_all(pi_ne_id             => pi_ne_id
                           ,pi_not_found_sqlcode => -20002
                           ).ne_gty_group_type;
END get_ne_gty;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nt(pi_nt_type IN NM_TYPES.nt_type%TYPE)
               RETURN NM_TYPES%ROWTYPE IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_nt');
   Nm_Debug.proc_end(g_package_name,'get_nt');
   RETURN Nm3get.get_nt(pi_nt_type           => pi_nt_type
                       ,pi_not_found_sqlcode => -20003
                       );
END get_nt;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nt_unique( p_nt_type IN VARCHAR2)     RETURN NM_TYPES.nt_unique%TYPE IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_nt_unique');
   Nm_Debug.proc_end(g_package_name,'get_nt_unique');
   RETURN Nm3get.get_nt(pi_nt_type           => p_nt_type
                       ,pi_not_found_sqlcode => -20003
                       ).nt_unique;
END get_nt_unique;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nt_units( p_nt_type IN VARCHAR2)     RETURN NUMBER IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_nt_units');
   Nm_Debug.proc_end(g_package_name,'get_nt_units');
   RETURN Nm3get.get_nt(pi_nt_type           => p_nt_type
                       ,pi_not_found_sqlcode => -20003
                       ).nt_length_unit;
END get_nt_units;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nt_descr( p_nt_type IN VARCHAR2)     RETURN VARCHAR2 IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_nt_descr');
   Nm_Debug.proc_end(g_package_name,'get_nt_descr');
   RETURN Nm3get.get_nt(pi_nt_type           => p_nt_type
                       ,pi_not_found_sqlcode => -20003
                       ).nt_descr;
END get_nt_descr;
--
-----------------------------------------------------------------------------
--

FUNCTION get_nsc_descr( p_nt_type IN VARCHAR2, p_nsc_sub_class IN VARCHAR2)	RETURN VARCHAR2 IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_nsc_descr');
   Nm_Debug.proc_end(g_package_name,'get_nsc_descr');
   RETURN Nm3get.get_nsc (pi_nsc_nw_type     => p_nt_type
                         ,pi_nsc_sub_class   => p_nsc_sub_class
                         ,pi_raise_not_found => FALSE
                         ).nsc_descr;
END get_nsc_descr;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nsc_seq_no (p_nt_type       IN VARCHAR2
                        ,p_nsc_sub_class IN VARCHAR2
                        ) RETURN NM_TYPE_SUBCLASS.nsc_seq_no%TYPE IS
--
   l_retval NM_TYPE_SUBCLASS.nsc_seq_no%TYPE;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'get_nsc_seq_no');
--
   IF   p_nt_type       IS NOT NULL
    AND p_nsc_sub_class IS NOT NULL
    THEN
      l_retval := Nm3get.get_nsc (pi_nsc_nw_type     => p_nt_type
                                 ,pi_nsc_sub_class   => p_nsc_sub_class
                                 ,pi_raise_not_found => FALSE
                                 ).nsc_seq_no;
   END IF;
--
   l_retval := NVL(l_retval,-1);
--
   Nm_Debug.proc_end(g_package_name,'get_nsc_seq_no');
--
   RETURN l_retval;
--
END get_nsc_seq_no;
--
-----------------------------------------------------------------------------
--
FUNCTION get_xsp_descr( p_nt_type IN VARCHAR2, p_nsc_sub_class IN VARCHAR2, p_xsp IN VARCHAR2) RETURN VARCHAR2 IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_xsp_descr');
   Nm_Debug.proc_end(g_package_name,'get_xsp_descr');
   RETURN Nm3get.get_nwx (pi_nwx_nw_type       => p_nt_type
                         ,pi_nwx_x_sect        => p_xsp
                         ,pi_nwx_nsc_sub_class => p_nsc_sub_class
                         ,pi_raise_not_found   => FALSE
                         ).nwx_descr;
END get_xsp_descr;
--
-----------------------------------------------------------------------------
--
FUNCTION get_gty_units( p_gty IN VARCHAR2)        RETURN NUMBER IS
CURSOR c1 IS
  SELECT nt_length_unit
  FROM nm_group_types, NM_TYPES
  WHERE ngt_group_type = p_gty
  AND   ngt_nt_type = nt_type;

retval NUMBER;

BEGIN
   Nm_Debug.proc_start(g_package_name,'get_gty_units');
  OPEN c1;
  FETCH c1 INTO retval;
  IF c1%NOTFOUND THEN
    CLOSE c1;
    RAISE_APPLICATION_ERROR( -20004, 'Group Type does not exist');
  ELSE
    CLOSE c1;
  END IF;
   Nm_Debug.proc_end(g_package_name,'get_gty_units');
  RETURN retval;
END get_gty_units;
--
-----------------------------------------------------------------------------
--
FUNCTION Get_Nt_Type( p_ne_id IN NUMBER )         RETURN VARCHAR2 IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_nt_type');
   Nm_Debug.proc_end(g_package_name,'get_nt_type');
   RETURN Nm3get.get_ne_all (pi_ne_id             => p_ne_id
                            ,pi_not_found_sqlcode => -20003
                            ).ne_nt_type;
END Get_Nt_Type;
--
-----------------------------------------------------------------------------
--
/*
function get_nt_type( p_ne_unique in varchar2)    return varchar2 is
cursor c1 is
  select ne_nt_type
  from nm_elements
  where ne_id = p_ne_unique;
retval nm_types.nt_type%type;
begin
  open c1;
  fetch c1 into retval;
  if c1%notfound then
    close c1;
    raise_application_error( -20003, 'Network Type does not exist');
  else
    close c1;
  end if;
  return retval;
end get_nt_type;
*/
--
-----------------------------------------------------------------------------
--
FUNCTION get_gty(pi_gty IN nm_group_types.ngt_group_type%TYPE
                ) RETURN nm_group_types%ROWTYPE IS
   l_rec_ngt nm_group_types%ROWTYPE;
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_gty');
   IF pi_gty IS NOT NULL
    THEN
      l_rec_ngt := Nm3get.get_ngt (pi_ngt_group_type    => pi_gty
                                  ,pi_not_found_sqlcode => -20004
                                  );
   END IF;
   Nm_Debug.proc_end(g_package_name,'get_gty');
   RETURN l_rec_ngt;
END get_gty;
--
-----------------------------------------------------------------------------
--
FUNCTION get_gty_type( p_ne_id IN NUMBER )         RETURN VARCHAR2 IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_gty_type');
   Nm_Debug.proc_end(g_package_name,'get_gty_type');
   RETURN Nm3get.get_ne_all (pi_ne_id             => p_ne_id
                            ,pi_not_found_sqlcode => -20003
                            ).ne_gty_group_type;
END get_gty_type;
--
-----------------------------------------------------------------------------
--
FUNCTION get_gty_descr( p_gty IN VARCHAR2)        RETURN VARCHAR2 IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_gty_descr');
   Nm_Debug.proc_end(g_package_name,'get_gty_descr');
   RETURN get_gty(p_gty).ngt_descr;
END get_gty_descr;
--
-----------------------------------------------------------------------------
--
FUNCTION get_gty_sub_group_allowed(pi_group_type IN nm_group_types.ngt_group_type%TYPE
                                  ) RETURN nm_group_types.ngt_sub_group_allowed%TYPE IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_gty_sub_group_allowed');
   Nm_Debug.proc_end(g_package_name,'get_gty_sub_group_allowed');
   RETURN Nm3get.get_ngt (pi_ngt_group_type  => pi_group_type
                         ,pi_raise_not_found => FALSE
                         ).ngt_sub_group_allowed;
END get_gty_sub_group_allowed;
--
-----------------------------------------------------------------------------
--
FUNCTION get_gty_icon(pi_group_type IN nm_group_types.ngt_group_type%TYPE
                     ) RETURN nm_group_types.ngt_icon_name%TYPE IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_gty_icon');
   Nm_Debug.proc_end(g_package_name,'get_gty_icon');
   RETURN Nm3get.get_ngt (pi_ngt_group_type  => pi_group_type
                         ,pi_raise_not_found => FALSE
                         ).ngt_icon_name;
END get_gty_icon;
--
-----------------------------------------------------------------------------
--
FUNCTION is_gty_linear( p_gty IN VARCHAR2)        RETURN VARCHAR2 IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'is_gty_linear');
   Nm_Debug.proc_end(g_package_name,'is_gty_linear');
   RETURN Nm3get.get_ngt (pi_ngt_group_type    => p_gty
                         ,pi_not_found_sqlcode => -20004
                         ).ngt_linear_flag;
END is_gty_linear;
--
-----------------------------------------------------------------------------
--
FUNCTION is_nt_linear( p_nt_type IN VARCHAR2) RETURN VARCHAR2 IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'is_nt_linear');
   Nm_Debug.proc_end(g_package_name,'is_nt_linear');
   RETURN Nm3get.get_nt (pi_nt_type           => p_nt_type
                        ,pi_not_found_sqlcode => -20001
                        ).nt_linear;
END is_nt_linear;
--
-----------------------------------------------------------------------------
--
FUNCTION gty_is_partial(pi_gty NM_GROUP_TYPES_ALL.ngt_group_type%TYPE
                       ) RETURN BOOLEAN IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'gty_is_partial');
   Nm_Debug.proc_end(g_package_name,'gty_is_partial');
   RETURN (Nm3get.get_ngt (pi_ngt_group_type    => pi_gty
                          ,pi_not_found_sqlcode => -20004
                          ).ngt_partial='Y');
END gty_is_partial;
--
-----------------------------------------------------------------------------
--
FUNCTION is_nt_datum( p_nt_type IN VARCHAR2 )     RETURN VARCHAR2 IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'is_nt_datum');
   Nm_Debug.proc_end(g_package_name,'is_nt_datum');
   RETURN Nm3get.get_nt (pi_nt_type           => p_nt_type
                        ,pi_not_found_sqlcode => -20001
                        ).nt_datum;
END is_nt_datum;
--
-----------------------------------------------------------------------------
--
FUNCTION get_datum_nt(pi_gty IN nm_group_types.ngt_group_type%TYPE
                     ) RETURN NM_TYPES.nt_type%TYPE IS
--###################################################################################
--
-- This is seriously flawed! We can have multiple nng_nt_type for each nng_group_type
--
--###################################################################################
  CURSOR c_nng(p_gty nm_group_types.ngt_group_type%TYPE) IS
    with children as (SELECT   ngr_child_group_type
                      FROM     nm_group_relations
                      CONNECT BY   PRIOR ngr_child_group_type = ngr_parent_group_type
                      START WITH   ngr_parent_group_type = p_gty
                      UNION
                      SELECT   nng_group_type
                        FROM   nm_nt_groupings
                       WHERE   nng_group_type = p_gty )
     select unique nng_nt_type from children, nm_nt_groupings
     where ngr_child_group_type = nng_group_type;


  l_retval NM_TYPES.nt_type%TYPE;

BEGIN
  Nm_Debug.proc_start(g_package_name,'get_datum_nt');

  OPEN c_nng(p_gty => pi_gty);
  FETCH c_nng INTO l_retval;
  IF c_nng%NOTFOUND
  THEN
    CLOSE c_nng;
    RAISE_APPLICATION_ERROR( -20030, 'Group type has no datum.');
  ELSE
    CLOSE c_nng;
  END IF;

  Nm_Debug.proc_end(g_package_name,'get_datum_nt');

  RETURN l_retval;
--
END get_datum_nt;
--
-----------------------------------------------------------------------------
--
FUNCTION get_datum_nt(pi_ne_id nm_elements.ne_id%TYPE
                     ) RETURN NM_TYPES.nt_type%TYPE IS
  l_ne_rec nm_elements%ROWTYPE;
  l_retval NM_TYPES.nt_type%TYPE;
BEGIN
--
  Nm_Debug.proc_start(g_package_name,'get_datum_nt');
--
  l_ne_rec := Nm3net.get_ne_all_rowtype(pi_ne_id => pi_ne_id);
--
  IF Nm3net.is_nt_datum(p_nt_type => l_ne_rec.ne_nt_type) = 'Y'
  THEN
    l_retval := l_ne_rec.ne_nt_type;
  ELSE
    l_retval := Nm3net.get_datum_nt(pi_gty => l_ne_rec.ne_gty_group_type);
  END IF;
--
  Nm_Debug.proc_end(g_package_name,'get_datum_nt');
  RETURN l_retval;
--
END get_datum_nt;
--
-----------------------------------------------------------------------------
--
FUNCTION Get_Node_Name ( p_no_id IN NUMBER ) RETURN VARCHAR2 IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_node_name');
   Nm_Debug.proc_end(g_package_name,'get_node_name');
   RETURN Nm3get.get_no (pi_no_node_id      => p_no_id
                        ,pi_raise_not_found => FALSE
                        ).no_node_name;
END Get_Node_Name;
--
-----------------------------------------------------------------------------
--
FUNCTION get_node_name_format ( p_no_type IN VARCHAR2 ) RETURN VARCHAR2 IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_node_name_format');
   Nm_Debug.proc_end(g_package_name,'get_node_name_format');
   RETURN Nm3get.get_nnt (pi_nnt_type        => p_no_type
                         ,pi_raise_not_found => FALSE
                         ).nnt_no_name_format;
END get_node_name_format;
--
-----------------------------------------------------------------------------
--
FUNCTION make_node_name(pi_no_type IN NM_NODE_TYPES.nnt_type%TYPE
                       ,pi_no_id   IN nm_nodes.no_node_id%TYPE
                       ) RETURN nm_nodes.no_node_name%TYPE IS
  l_name_format NM_NODE_TYPES.nnt_no_name_format%TYPE;
  l_node_name nm_nodes.no_node_name%TYPE;
BEGIN
   Nm_Debug.proc_start(g_package_name,'make_node_name');
  --get format for name
  l_name_format := get_node_name_format(pi_no_type);

  IF l_name_format IS NOT NULL THEN
    l_node_name := LTRIM(TO_CHAR(pi_no_id, l_name_format));
  ELSE
    l_node_name := NULL; --pi_no_id;
  END IF;

   Nm_Debug.proc_end(g_package_name,'make_node_name');
  RETURN l_node_name;
END make_node_name;
--
-----------------------------------------------------------------------------
--
FUNCTION get_node_descr ( p_no_id IN NUMBER ) RETURN VARCHAR2 IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_node_descr');
   Nm_Debug.proc_end(g_package_name,'get_node_descr');
   RETURN Nm3get.get_no (pi_no_node_id      => p_no_id
                        ,pi_raise_not_found => FALSE
                        ).no_descr;
END get_node_descr;
--
-----------------------------------------------------------------------------
--
FUNCTION get_node_id ( p_no_name IN VARCHAR2 ) RETURN NUMBER IS
   retval nm_nodes.no_node_id%TYPE;
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_node_id');
   SELECT no_node_id
    INTO  retval
    FROM  nm_nodes
   WHERE  no_node_name = p_no_name;
   Nm_Debug.proc_end(g_package_name,'get_node_id');
   RETURN retval;
EXCEPTION
   WHEN NO_DATA_FOUND
    THEN
      Hig.raise_ner (pi_appl               => Nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'NM_NODES.NO_NODE_NAME="'||p_no_name||'"'
                    );
   WHEN TOO_MANY_ROWS
    THEN
      Hig.raise_ner (pi_appl               => Nm3type.c_net
                    ,pi_id                 => 289
                    ,pi_supplementary_info => 'NM_NODES.NO_NODE_NAME="'||p_no_name||'"'
                    );
END get_node_id;
--
-----------------------------------------------------------------------------
--
FUNCTION get_node_id ( p_no_name IN VARCHAR2, p_no_node_type IN VARCHAR2  ) RETURN NUMBER IS

BEGIN
   Nm_Debug.proc_start(g_package_name,'get_node_id');
   Nm_Debug.proc_end(g_package_name,'get_node_id');
   RETURN Nm3get.get_no (pi_no_node_name    => p_no_name
                        ,pi_no_node_type    => p_no_node_type
                        ,pi_raise_not_found => FALSE
                        ).no_node_id;
END get_node_id;
--
-----------------------------------------------------------------------------
--
FUNCTION get_next_node_id RETURN nm_nodes.no_node_id%TYPE IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_next_node_id');
   Nm_Debug.proc_end(g_package_name,'get_next_node_id');
  RETURN Nm3seq.next_no_node_id_seq;
END get_next_node_id;
--
-----------------------------------------------------------------------------
--
FUNCTION node_in_use(pi_node IN nm_nodes.no_node_id%TYPE
                    ) RETURN BOOLEAN IS

  CURSOR c1 IS
    SELECT
      1
    FROM
      nm_node_usages
    WHERE
      nnu_no_node_id = pi_node;
  l_temp PLS_INTEGER;

  l_retval BOOLEAN;
BEGIN
   Nm_Debug.proc_start(g_package_name,'node_in_use');
  OPEN c1;
    FETCH c1 INTO l_temp;
    l_retval := c1%FOUND;
  CLOSE c1;

   Nm_Debug.proc_end(g_package_name,'node_in_use');
  RETURN l_retval;
END node_in_use;
--
----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--
FUNCTION get_ne_column_value ( p_ne_id IN NUMBER, p_column_name IN VARCHAR2) RETURN VARCHAR2 IS
   c_str  VARCHAR2(2000):= 'select '||p_column_name||' from nm_elements where ne_id = '||TO_CHAR( p_ne_id );
   retval VARCHAR2(30);
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_ne_column_value');
  EXECUTE IMMEDIATE c_str INTO retval;
   Nm_Debug.proc_end(g_package_name,'get_ne_column_value');
  RETURN retval;
END get_ne_column_value;
--
--
-----------------------------------------------------------------------------
--
FUNCTION get_node_slk(p_ne_id      IN NUMBER
                     ,p_no_node_id IN NUMBER
                     ,p_sub_class  IN nm_elements.ne_sub_class%TYPE DEFAULT NULL
                     ,p_datum_ne_id      IN nm_elements.ne_id%TYPE DEFAULT NULL
                     ) RETURN NUMBER IS
--
   CURSOR c1 (c_node_id nm_node_usages.nnu_no_node_id%TYPE
             ,c_ne_id   nm_members.nm_ne_id_in%TYPE
             ,c_sub_class nm_elements.ne_sub_class%TYPE
             ) IS
   SELECT nm_slk
         ,nm_begin_mp
         ,nm_end_mp
         ,nm_cardinality
         ,ne_length
         ,ne_sub_class
         ,nnu_node_type
         ,ne_id
         ,nnu_chain
    FROM  nm_members
         ,nm_elements
         ,nm_node_usages
         ,NM_TYPE_SUBCLASS
   WHERE  nm_ne_id_in    = c_ne_id
    AND   nm_ne_id_of    = ne_id
    AND   ne_id          = nnu_ne_id
    AND   nnu_no_node_id = c_node_id
    AND   nsc_nw_type (+)    = ne_nt_type
    AND   nsc_sub_class (+)  = ne_sub_class
   ORDER BY DECODE( NVL(ne_sub_class, '—$%^'), c_sub_class, 'A', 'B')
           ,nnu_node_type
           ,nsc_seq_no;
--
   l_rowtype c1%ROWTYPE;
--
   l_p_unit  NUMBER;
   l_c_unit  NUMBER;
--
   l_found   BOOLEAN := FALSE;
--
   retval    NUMBER;
--
BEGIN
--
   FOR cs_rec IN c1 (p_no_node_id,p_ne_id,p_sub_class)
    LOOP
--
      l_found := TRUE;
--
      IF c1%rowcount = 1
       THEN
         -- Store the first one in the rowtype record
         l_rowtype := cs_rec;
         IF p_sub_class IS NULL
          AND p_datum_ne_id IS NULL
          THEN
            -- We aren't looking up by subclass so just leave with the first one
            EXIT;
         END IF;
      END IF;
--
      IF cs_rec.ne_sub_class  = NVL(p_sub_class, cs_rec.ne_sub_class)
       AND cs_rec.ne_id       = NVL(p_datum_ne_id, cs_rec.ne_id)
       THEN
         -- This one is a match with the passed subclass, so we'll use this one
         l_rowtype := cs_rec;
         EXIT;
      END IF;
--
   END LOOP;
--
   IF NOT l_found
    THEN
      RAISE_APPLICATION_ERROR( -20001, 'No node connectivity on this route - SLK cannot be derived' );
   END IF;
--
   Nm3net.get_group_units( p_ne_id, l_p_unit, l_c_unit );

   IF Nm3net.route_direction( l_rowtype.nnu_node_type, l_rowtype.nm_cardinality ) >0 THEN
-- IF l_rowtype.nm_cardinality > 0 THEN
      retval := l_rowtype.nm_slk;

   ELSE
      retval := l_rowtype.nm_slk +
                Nm3unit.convert_unit( l_c_unit, l_p_unit,
                    (NVL(l_rowtype.nm_end_mp,l_rowtype.ne_length))-l_rowtype.nm_begin_mp) ;

   END IF;
--
   RETURN retval;
--
END get_node_slk;
--
-----------------------------------------------------------------------------
--
FUNCTION get_max_slk( pi_ne_id IN NUMBER ) RETURN NUMBER IS
--
   CURSOR c1 (c_route  nm_members.nm_ne_id_in%TYPE
             ,c_c_unit NM_UNITS.un_unit_id%TYPE
             ,c_p_unit NM_UNITS.un_unit_id%TYPE
             ) IS
    SELECT MAX(nm_slk + Nm3unit.convert_unit(c_c_unit,c_p_unit,NVL( nm_end_mp,ne_length)-nm_begin_mp))
     FROM  nm_elements
          ,nm_members
    WHERE  nm_ne_id_in = c_route
     AND   nm_ne_id_of = ne_id;
--
   retval NUMBER;
--
   l_p_unit NUMBER;
   l_c_unit NUMBER;
--
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_max_slk');
   Nm3net.get_group_units( pi_ne_id, l_p_unit, l_c_unit );
   OPEN  c1 (pi_ne_id, l_c_unit, l_p_unit);
   FETCH c1 INTO retval;
   IF c1%NOTFOUND
    THEN
      CLOSE c1;
      RAISE_APPLICATION_ERROR( -20001, 'Element does not exist');
   END IF;
   CLOSE c1;
--
   Nm_Debug.proc_end(g_package_name,'get_max_slk');
   RETURN retval;
--
END get_max_slk;
--
-----------------------------------------------------------------------------
--
FUNCTION get_max_true( pi_ne_id IN NUMBER ) RETURN NUMBER IS
--
   CURSOR c1 (c_route  nm_members.nm_ne_id_in%TYPE
             ,c_c_unit NM_UNITS.un_unit_id%TYPE
             ,c_p_unit NM_UNITS.un_unit_id%TYPE
             ) IS
    SELECT MAX(nm_true + Nm3unit.convert_unit(c_c_unit,c_p_unit,NVL( nm_end_mp,ne_length)-nm_begin_mp))
     FROM  nm_elements
          ,nm_members
    WHERE  nm_ne_id_in = c_route
     AND   nm_ne_id_of = ne_id;
--
   retval NUMBER;
--
   l_p_unit NUMBER;
   l_c_unit NUMBER;
--
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_max_true');
   Nm3net.get_group_units( pi_ne_id, l_p_unit, l_c_unit );
   OPEN  c1 (pi_ne_id, l_c_unit, l_p_unit);
   FETCH c1 INTO retval;
   IF c1%NOTFOUND
    THEN
      CLOSE c1;
      RAISE_APPLICATION_ERROR( -20001, 'Element does not exist');
   END IF;
   CLOSE c1;
--
   Nm_Debug.proc_end(g_package_name,'get_max_true');
   RETURN retval;
--
END get_max_true;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_node_slk
     (pi_route_ne_id        IN     nm_members.nm_ne_id_in%TYPE
     ,pi_nw_type            IN     NM_TYPES.nt_type%TYPE
     ,pi_new_node_id        IN     nm_nodes.no_node_id%TYPE
     ,pi_new_node_type      IN     nm_node_usages.nnu_node_type%TYPE
     ,pi_new_element_length IN     nm_elements.ne_length%TYPE
     ,pi_new_sub_class      IN     nm_elements.ne_sub_class%TYPE
     ,po_new_slk            IN OUT nm_members.nm_slk%TYPE
     ,po_new_cardinality    IN OUT nm_members.nm_cardinality%TYPE
     ,po_warning            IN OUT VARCHAR2
     )
IS
   l_true_new nm_members.nm_true%TYPE;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'get_node_slk');
--
   get_node_slk_true
           (pi_route_ne_id
           ,pi_nw_type
           ,pi_new_node_id
           ,pi_new_node_type
           ,pi_new_element_length
           ,pi_new_sub_class
           ,po_new_slk
           ,l_true_new
           ,po_new_cardinality
           ,po_warning
           );
--
   Nm_Debug.proc_end(g_package_name,'get_node_slk');
--
END get_node_slk;
--
----------------------------------------------------------------------------------
--
PROCEDURE get_node_slk_true
     (pi_route_ne_id        IN     nm_members.nm_ne_id_in%TYPE
     ,pi_nw_type            IN     NM_TYPES.nt_type%TYPE
     ,pi_new_node_id        IN     nm_nodes.no_node_id%TYPE
     ,pi_new_node_type      IN     nm_node_usages.nnu_node_type%TYPE
     ,pi_new_element_length IN     nm_elements.ne_length%TYPE
     ,pi_new_sub_class      IN     nm_elements.ne_sub_class%TYPE
     ,po_new_slk            IN OUT nm_members.nm_slk%TYPE
     ,po_new_true           IN OUT nm_members.nm_true%TYPE
     ,po_new_cardinality    IN OUT nm_members.nm_cardinality%TYPE
     ,po_warning            IN OUT VARCHAR2
     )
IS
--
   CURSOR cs_slk (p_node_id   nm_nodes.no_node_id%TYPE
                 ,p_ne_id_in  nm_members.nm_ne_id_in%TYPE
                 ) IS
   SELECT ne_unique
         ,ne_length
         ,nnu_node_type
         ,nm_slk
         ,nm_true
         ,nm_cardinality
         ,ne_sub_class
    FROM  nm_members
         ,nm_elements
         ,nm_node_usages
         ,NM_TYPE_SUBCLASS
    WHERE nm_ne_id_of    = ne_id
     AND  nm_ne_id_in    = p_ne_id_in
     AND  nnu_ne_id      = ne_id
     AND  nnu_no_node_id = p_node_id
     AND  ne_sub_class   = nsc_sub_class
     AND  ne_nt_type     = nsc_nw_type
   ORDER BY nsc_seq_no;
--
   CURSOR cs_valid (p_nw_type            NM_TYPE_SUBCLASS_RESTRICTIONS.nsr_nw_type%TYPE
                   ,p_sub_class_new      NM_TYPE_SUBCLASS_RESTRICTIONS.nsr_sub_class_new%TYPE
                   ,p_sub_class_existing NM_TYPE_SUBCLASS_RESTRICTIONS.nsr_sub_class_existing%TYPE
                   ) IS
   SELECT nsr_allowed
    FROM  NM_TYPE_SUBCLASS_RESTRICTIONS
   WHERE  nsr_nw_type            = p_nw_type
    AND   nsr_sub_class_new      = p_sub_class_new
    AND   nsr_sub_class_existing = p_sub_class_existing;
--
   l_rec_slk     cs_slk%ROWTYPE;
--
   l_nsr_allowed NM_TYPE_SUBCLASS_RESTRICTIONS.nsr_allowed%TYPE;
--
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_node_slk_true');
--
-- Set OUT parameters to defaults
--
   po_new_slk         := 0;
   po_new_cardinality := 1;
   po_warning         := NULL;
--
   OPEN  cs_slk (pi_new_node_id,pi_route_ne_id);
   FETCH cs_slk INTO l_rec_slk;
   CLOSE cs_slk;
--
   IF l_rec_slk.ne_unique IS NOT NULL
    THEN
      --
      -- We have a matching record
      --
      OPEN  cs_valid (pi_nw_type
                     ,pi_new_sub_class
                     ,l_rec_slk.ne_sub_class
                     );
--
      FETCH cs_valid INTO l_nsr_allowed;
--
      IF cs_valid%NOTFOUND
       THEN
         po_warning := 'No nm_type_subclass_restrictions record found for -'
                       ||pi_nw_type||','
                       ||pi_new_sub_class||','
                       ||l_rec_slk.ne_sub_class;
      ELSIF l_nsr_allowed = 'N'
       THEN
         po_warning := 'Combination not allowed -'
                       ||pi_nw_type||','
                       ||pi_new_sub_class||','
                       ||l_rec_slk.ne_sub_class;
      END IF;
--
      CLOSE cs_valid;
--
      calculate_node_slk (pi_ne_id           => pi_route_ne_id
                         ,pi_type_new        => pi_new_node_type
                         ,pi_type_old        => l_rec_slk.nnu_node_type
                         ,pi_slk_old         => l_rec_slk.nm_slk
                         ,pi_true_old        => l_rec_slk.nm_true
                         ,pi_cardinality_old => l_rec_slk.nm_cardinality
                         ,pi_length_new      => pi_new_element_length
                         ,pi_length_old      => l_rec_slk.ne_length
                         ,po_slk_new         => po_new_slk
                         ,po_cardinality_new => po_new_cardinality
                         ,po_true_new        => po_new_true
                         );
--
   END IF;
   Nm_Debug.proc_end(g_package_name,'get_node_slk_true');
--
END get_node_slk_true;
--
----------------------------------------------------------------------------------
--
PROCEDURE calculate_node_slk(pi_ne_id           IN     nm_elements.ne_id%TYPE
                            ,pi_type_new        IN     NM_TYPES.nt_type%TYPE
                            ,pi_type_old        IN     NM_TYPES.nt_type%TYPE
                            ,pi_slk_old         IN     nm_members.nm_slk%TYPE
                            ,pi_true_old        IN     nm_members.nm_true%TYPE
                            ,pi_cardinality_old IN     nm_members.nm_cardinality%TYPE
                            ,pi_length_new      IN     nm_elements.ne_length%TYPE
                            ,pi_length_old      IN     nm_elements.ne_length%TYPE
                            ,po_slk_new         IN OUT nm_members.nm_slk%TYPE
                            ,po_cardinality_new IN OUT nm_members.nm_cardinality%TYPE
                            ,po_true_new        IN OUT nm_members.nm_true%TYPE
                            ) IS
--
   l_type_new NUMBER;
   l_type_old NUMBER;
--
   l_p_unit   NUMBER;
   l_c_unit   NUMBER;
--
-- Local function to return the sign for the node type
--  S(tart) is +ve, E(end) is -ve
--
BEGIN
   Nm_Debug.proc_start(g_package_name,'calculate_node_slk');

   get_group_units(pi_ne_id       => pi_ne_id
                  ,po_group_units => l_p_unit
                  ,po_child_units => l_c_unit);
--
   l_type_new := get_type_sign(pi_type_new);
   l_type_old := get_type_sign(pi_type_old);
--
   po_cardinality_new := - (l_type_new * l_type_old * pi_cardinality_old);
--
   IF (po_cardinality_new * l_type_new) = -1
    THEN
      po_slk_new  := pi_slk_old - Nm3unit.convert_unit(l_c_unit, l_p_unit, pi_length_new);
      po_true_new := pi_true_old - Nm3unit.convert_unit(l_c_unit, l_p_unit, pi_length_new);
   ELSE
      po_slk_new  := pi_slk_old + Nm3unit.convert_unit(l_c_unit, l_p_unit, pi_length_old);
      po_true_new := pi_true_old + Nm3unit.convert_unit(l_c_unit, l_p_unit, pi_length_old);
   END IF;
   Nm_Debug.proc_end(g_package_name,'calculate_node_slk');
--
END calculate_node_slk;
--
----------------------------------------------------------------------------------
--
FUNCTION check_element_connectivity
           (pi_ne_id1 IN nm_node_usages.nnu_ne_id%TYPE
           ,pi_ne_id2 IN nm_node_usages.nnu_ne_id%TYPE
           ) RETURN BOOLEAN IS
--
   l_shared_node nm_node_usages.nnu_no_node_id%TYPE;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'check_element_connectivity');
   l_shared_node := get_element_shared_node(pi_ne_id1,pi_ne_id2);
   Nm_Debug.proc_end(g_package_name,'check_element_connectivity');
   RETURN (l_shared_node IS NOT NULL);
--
END check_element_connectivity;
--
----------------------------------------------------------------------------------
--
FUNCTION get_element_shared_node
           (pi_ne_id1 IN nm_node_usages.nnu_ne_id%TYPE
           ,pi_ne_id2 IN nm_node_usages.nnu_ne_id%TYPE
           ) RETURN nm_node_usages.nnu_no_node_id%TYPE IS
--
   CURSOR cs_check (p_ne_id_1 nm_node_usages.nnu_ne_id%TYPE
                   ,p_ne_id_2 nm_node_usages.nnu_ne_id%TYPE
                   ) IS
   SELECT nnu1.nnu_no_node_id
    FROM  nm_node_usages nnu1
         ,nm_node_usages nnu2
   WHERE  nnu1.nnu_ne_id      = p_ne_id_1
    AND   nnu2.nnu_ne_id      = p_ne_id_2
    AND   nnu1.nnu_no_node_id = nnu2.nnu_no_node_id
   ORDER BY nnu1.nnu_node_type;
--
   l_retval nm_node_usages.nnu_no_node_id%TYPE;
--
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_element_shared_node');
--
   OPEN  cs_check (pi_ne_id1,pi_ne_id2);
   FETCH cs_check INTO l_retval;
   IF cs_check%NOTFOUND
    THEN
      l_retval := NULL;
   END IF;
   CLOSE cs_check;
   Nm_Debug.proc_end(g_package_name,'get_element_shared_node');
--
   RETURN l_retval;
--
END get_element_shared_node;
--
----------------------------------------------------------------------------------
--
FUNCTION check_for_ngr_loops
           (pi_parent_group_type IN nm_group_relations.ngr_parent_group_type%TYPE
           ,pi_child_group_type IN nm_group_relations.ngr_child_group_type%TYPE
           ) RETURN BOOLEAN IS
--
   CURSOR cs_check (pi_parent_group_type IN nm_group_relations.ngr_parent_group_type%TYPE
			 ,pi_child_group_type IN nm_group_relations.ngr_child_group_type%TYPE
                   ) IS
	SELECT 		ngr_child_group_type
	FROM  		nm_group_relations
	START WITH 		ngr_child_group_type IN (pi_parent_group_type,pi_child_group_type)
	CONNECT BY PRIOR 	ngr_parent_group_type = ngr_child_group_type ;
--
   l_dummy  cs_check%ROWTYPE;
--
   l_retval BOOLEAN;
--
   loop_in_data EXCEPTION;
   PRAGMA EXCEPTION_INIT (loop_in_data, -1436);
--
BEGIN
   Nm_Debug.proc_start(g_package_name,'check_for_ngr_loops');
--
   OPEN  cs_check (pi_parent_group_type,pi_child_group_type);
--
   LOOP
      FETCH cs_check INTO l_dummy;
--
      l_retval := cs_check%FOUND;
--
      IF NOT l_retval THEN
         EXIT;
      END IF;
   END LOOP;
--
   CLOSE cs_check;
   Nm_Debug.proc_end(g_package_name,'check_for_ngr_loops');
--
   RETURN TRUE;
--
EXCEPTION
	WHEN loop_in_data THEN
		RETURN FALSE;
END check_for_ngr_loops;
--
-----------------------------------------------------------------------------
--
FUNCTION get_next_nte_id RETURN NUMBER IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_next_nte_id');
   Nm_Debug.proc_end(g_package_name,'get_next_nte_id');
  RETURN Nm3seq.next_nte_id_seq;
END get_next_nte_id;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_grid_refs	( p_node_id IN NUMBER
				, p_grid_east OUT NUMBER
				, p_grid_north OUT NUMBER
				) IS
CURSOR c1 IS
  	SELECT 	np_grid_east,
			np_grid_north
	FROM 		NM_POINTS ,
			nm_nodes
	WHERE 	no_np_id = np_id
	AND 		no_node_id = p_node_id;

v_grid_east NUMBER := NULL;
v_grid_north NUMBER:= NULL;

BEGIN
   Nm_Debug.proc_start(g_package_name,'get_grid_refs');
  IF p_node_id IS NOT NULL THEN
    OPEN c1;
    FETCH c1 INTO v_grid_east,v_grid_north ;
    CLOSE c1;
  END IF;

  p_grid_east := v_grid_east ;
  p_grid_north := v_grid_north ;
   Nm_Debug.proc_end(g_package_name,'get_grid_refs');
END get_grid_refs;
--
-----------------------------------------------------------------------------
--
FUNCTION get_next_control ( 	p_child_ne_id IN NUMBER ,
					p_parent_type IN VARCHAR2,
					p_parent_id   IN NUMBER DEFAULT NULL,
					p_child_type  IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2 IS


v_control_column VARCHAR2(30) ;
v_parent_ne_id NUMBER := p_parent_id;
v_child_type  VARCHAR2(4) := p_child_type;

v_select_statement VARCHAR2(1000);
v_update_statement VARCHAR2(1000);
retval   NUMBER;

CURSOR c1 IS 	SELECT nti_code_control_column
			FROM	NM_TYPE_INCLUSION
			WHERE nti_nw_parent_type = p_parent_type
			AND	nti_nw_child_type  = v_child_type;

BEGIN

   Nm_Debug.proc_start(g_package_name,'get_next_control');
      IF v_parent_ne_id IS NULL THEN
	  v_parent_ne_id := Nm3net.get_parent_ne_id (p_child_ne_id, p_parent_type);
	END IF;
	IF v_child_type IS NULL THEN
	  v_child_type := Nm3net.Get_Nt_Type (p_child_ne_id);
	END IF;

	OPEN c1;
	FETCH c1 INTO v_control_column;
	CLOSE c1;

	v_select_statement  := 	'SELECT NVL(to_number('||v_control_column||'),0) + 1 '
					||'FROM nm_elements '
					||'WHERE ne_id = '||TO_CHAR(v_parent_ne_id)||' '
					||'FOR UPDATE OF '||v_control_column||' NOWAIT';

	EXECUTE IMMEDIATE v_select_statement INTO retval;


	v_update_statement := 	'UPDATE nm_elements '
					||'SET '||v_control_column||' = '||TO_CHAR(retval)||' '
					||'WHERE ne_id = '||TO_CHAR(v_parent_ne_id);


	EXECUTE IMMEDIATE v_update_statement;
   Nm_Debug.proc_end(g_package_name,'get_next_control');
	RETURN TO_CHAR(retval);
END;
--
-----------------------------------------------------------------------------
--
FUNCTION get_parent_ne_id ( 	p_child_ne_id IN NUMBER,
					p_parent_type IN VARCHAR2) RETURN NUMBER IS
--
   v_child_type        VARCHAR2(4) := Nm3net.Get_Nt_Type(p_child_ne_id);
   v_parent_column     VARCHAR2(30);
   v_child_column      VARCHAR2(30);
   v_childs_group_name VARCHAR2(2000);
   v_query_string      VARCHAR2(1000);
   v_parent_ne_id      NUMBER;
   l_is_inclusion      BOOLEAN;
   l_cur               Nm3type.ref_cursor;
--
   CURSOR cs_parent IS
   SELECT nti_parent_column
         ,nti_child_column
    FROM  NM_TYPE_INCLUSION
   WHERE  nti_nw_parent_type = p_parent_type
    AND   nti_nw_child_type  = v_child_type;
BEGIN
   --
   Nm_Debug.proc_start(g_package_name,'get_parent_ne_id');
   --
   OPEN  cs_parent;
   FETCH cs_parent INTO v_parent_column,v_child_column;
   l_is_inclusion := cs_parent%FOUND;
   CLOSE cs_parent;
   --
   IF NOT l_is_inclusion
    THEN
      v_parent_ne_id := p_child_ne_id;
   ELSE
--
      v_query_string := 'select '||v_child_column||' from nm_elements_all '||'where ne_id = '||TO_CHAR(p_child_ne_id);
      OPEN  l_cur FOR  v_query_string;
      FETCH l_cur INTO v_childs_group_name;
      IF l_cur%NOTFOUND
       THEN
         CLOSE l_cur;
         RAISE_APPLICATION_ERROR(-20001,'Child element (ne_id-'||p_child_ne_id||') not found');
      END IF;
      CLOSE l_cur;
--
      v_query_string := 'select ne_id'
            ||CHR(10)||' from   nm_elements_all '
            ||CHR(10)||' where  '||v_parent_column||' = '||Nm3flx.string(v_childs_group_name)
            ||CHR(10)||'  and   ne_nt_type = '||Nm3flx.string(p_parent_type);
      OPEN  l_cur FOR  v_query_string;
      FETCH l_cur INTO v_parent_ne_id;
      IF l_cur%NOTFOUND
       THEN
         v_parent_ne_id := p_child_ne_id;
--         CLOSE l_cur;
--         RAISE_APPLICATION_ERROR(-20001,'No parent found with '||v_parent_column||' = '||nm3flx.string(v_childs_group_name)||' AND ne_nt_type = '||nm3flx.string(p_parent_type));
      END IF;
      CLOSE l_cur;
   END IF;
   Nm_Debug.proc_end(g_package_name,'get_parent_ne_id');
   RETURN v_parent_ne_id ;
END;
--
----------------------------------------------------------------------------------
--
PROCEDURE insert_any_element (p_rec_ne         IN OUT nm_elements%ROWTYPE
                             ,p_nm_cardinality IN     nm_members.nm_cardinality%TYPE DEFAULT NULL
                             ,p_auto_include   IN     BOOLEAN DEFAULT TRUE
                             ) IS
--
   CURSOR cs_inclusion_child (c_nt_type NM_TYPE_INCLUSION.nti_nw_child_type%TYPE) IS
   SELECT nti_parent_column
         ,nti_child_column
         ,nti_code_control_column
         ,nti_nw_parent_type
         ,nti_auto_create
         ,nti_auto_include
    FROM  NM_TYPE_INCLUSION
   WHERE  nti_nw_child_type = c_nt_type;
--
   l_tab_parent_column       Nm3type.tab_varchar30;
   l_tab_child_column        Nm3type.tab_varchar30;
   l_tab_code_control_column Nm3type.tab_varchar30;
   l_tab_parent_type         Nm3type.tab_varchar4;
   l_tab_auto_create         Nm3type.tab_varchar4;
   l_tab_auto_include        Nm3type.tab_varchar4;
--
   l_tab_rec_nm              Nm3type.tab_rec_nm;
--
   record_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT(record_locked,-54);
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'insert_any_element');
--
   IF NOT Nm3reclass.is_subclass_valid (p_rec_ne.ne_nt_type, p_rec_ne.ne_sub_class)
    THEN
      Hig.raise_ner(pi_appl               => Nm3type.c_net
                   ,pi_id                 => 224
                   ,pi_supplementary_info => p_rec_ne.ne_sub_class||':'||p_rec_ne.ne_nt_type
                   );
   END IF;
--
   g_dyn_rec_ne := p_rec_ne;
--
   g_dyn_rec_ne.ne_id            := g_dyn_rec_ne.ne_id;
   IF g_dyn_rec_ne.ne_id IS NULL
    THEN
      g_dyn_rec_ne.ne_id         := Nm3net.get_next_ne_id;
   END IF;
   g_dyn_rec_ne.ne_type          := NVL(g_dyn_rec_ne.ne_type,'S');
   g_dyn_rec_ne.ne_admin_unit    := NVL(g_dyn_rec_ne.ne_admin_unit,1);
   g_dyn_rec_ne.ne_start_date    := g_dyn_rec_ne.ne_start_date;
   IF g_dyn_rec_ne.ne_start_date IS NULL
    THEN
      g_dyn_rec_ne.ne_start_date := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
   END IF;

   --validate flex columns to handle any derived values
   Nm3nwval.validate_nw_element_cols(p_ne_nt_type    => g_dyn_rec_ne.ne_nt_type
                                    ,p_ne_owner      => g_dyn_rec_ne.ne_owner
                                    ,p_ne_name_1     => g_dyn_rec_ne.ne_name_1
                                    ,p_ne_name_2     => g_dyn_rec_ne.ne_name_2
                                    ,p_ne_prefix     => g_dyn_rec_ne.ne_prefix
                                    ,p_ne_number     => g_dyn_rec_ne.ne_number
                                    ,p_ne_sub_type   => g_dyn_rec_ne.ne_sub_type
                                    ,p_ne_no_start   => g_dyn_rec_ne.ne_no_start
                                    ,p_ne_no_end     => g_dyn_rec_ne.ne_no_end
                                    ,p_ne_sub_class  => g_dyn_rec_ne.ne_sub_class
                                    ,p_ne_nsg_ref    => g_dyn_rec_ne.ne_nsg_ref
                                    ,p_ne_version_no => g_dyn_rec_ne.ne_version_no
                                    ,p_ne_group      => g_dyn_rec_ne.ne_group
                                    ,p_ne_start_date => g_dyn_rec_ne.ne_start_date
                                    ,p_ne_gty_group_type => g_dyn_rec_ne.ne_gty_group_type
                                    ,p_ne_admin_unit     => g_dyn_rec_ne.ne_admin_unit);
--
   OPEN  cs_inclusion_child (p_rec_ne.ne_nt_type);
   FETCH cs_inclusion_child
    BULK COLLECT
    INTO l_tab_parent_column
        ,l_tab_child_column
        ,l_tab_code_control_column
        ,l_tab_parent_type
        ,l_tab_auto_create
        ,l_tab_auto_include;
   CLOSE cs_inclusion_child;
--
   FOR i IN 1..l_tab_parent_column.COUNT
    LOOP
      --
      DECLARE
      --
         l_no_parent            EXCEPTION;
         PRAGMA EXCEPTION_INIT (l_no_parent, -20001);
      --
         c_auto_create CONSTANT BOOLEAN := (l_tab_auto_create(i) = 'Y');
         l_tab_rec_ngt          Nm3type.tab_rec_ngt;
         l_optional             BOOLEAN;
      --
      BEGIN
      --
         l_optional := Nm3get.get_ntc (pi_ntc_nt_type     => p_rec_ne.ne_nt_type
                                      ,pi_ntc_column_name => l_tab_child_column(i)
                                      ,pi_raise_not_found => FALSE
                                      ).ntc_mandatory = 'N';
      --
         Nm3ddl.delete_tab_varchar;
         Nm3ddl.append_tab_varchar('DECLARE',FALSE);
         Nm3ddl.append_tab_varchar('   c_optional CONSTANT BOOLEAN := '||Nm3flx.boolean_to_char(l_optional)||';');
         Nm3ddl.append_tab_varchar('   CURSOR cs_parent IS');
         Nm3ddl.append_tab_varchar('   SELECT ne_id');
         Nm3ddl.append_tab_varchar('         ,ne_gty_group_type');
         Nm3ddl.append_tab_varchar('    FROM  nm_elements_all');
         Nm3ddl.append_tab_varchar('   WHERE '||l_tab_parent_column(i)||' = '||g_package_name||'.g_dyn_rec_ne.'||l_tab_child_column(i));
         Nm3ddl.append_tab_varchar('    AND   ne_nt_type = '||Nm3flx.string(l_tab_parent_type(i))||';');
         Nm3ddl.append_tab_varchar('   l_cs_parent_rt cs_parent%ROWTYPE;');
         Nm3ddl.append_tab_varchar('   l_found        BOOLEAN;');
         Nm3ddl.append_tab_varchar('   l_found_again  BOOLEAN;');
         Nm3ddl.append_tab_varchar('BEGIN');
         Nm3ddl.append_tab_varchar('   IF '||g_package_name||'.g_dyn_rec_ne.'||l_tab_child_column(i)||' IS NULL');
         Nm3ddl.append_tab_varchar('    THEN');
         Nm3ddl.append_tab_varchar('      IF c_optional');
         Nm3ddl.append_tab_varchar('       THEN');
         Nm3ddl.append_tab_varchar('         -- Column is optional in NTC - therefore OK for it to be NULL');
         Nm3ddl.append_tab_varchar('         '||g_package_name||'.g_dyn_ne_id := NULL;');
         Nm3ddl.append_tab_varchar('         '||g_package_name||'.g_dyn_val   := NULL;');
         Nm3ddl.append_tab_varchar('      ELSE');
         Nm3ddl.append_tab_varchar('         hig.raise_ner (pi_appl               => nm3type.c_hig');
         Nm3ddl.append_tab_varchar('                       ,pi_id                 => 107');
         Nm3ddl.append_tab_varchar('                       ,pi_supplementary_info => '||Nm3flx.string(l_tab_child_column(i)));
         Nm3ddl.append_tab_varchar('                       );');
         Nm3ddl.append_tab_varchar('      END IF;');
         Nm3ddl.append_tab_varchar('   ELSE');
         Nm3ddl.append_tab_varchar('      OPEN  cs_parent;');
         Nm3ddl.append_tab_varchar('      FETCH cs_parent');
         Nm3ddl.append_tab_varchar('       INTO '||g_package_name||'.g_dyn_ne_id');
         Nm3ddl.append_tab_varchar('           ,'||g_package_name||'.g_dyn_val;');
         Nm3ddl.append_tab_varchar('      l_found       := cs_parent%FOUND;');
         Nm3ddl.append_tab_varchar('      FETCH cs_parent INTO l_cs_parent_rt;');
         Nm3ddl.append_tab_varchar('      l_found_again := cs_parent%FOUND;');
         Nm3ddl.append_tab_varchar('      CLOSE cs_parent;');
         Nm3ddl.append_tab_varchar('      IF NOT l_found');
         Nm3ddl.append_tab_varchar('       THEN -- Parent not found');
         Nm3ddl.append_tab_varchar('         nm3type.g_exception_code := -20001;');
         Nm3ddl.append_tab_varchar('         nm3type.g_exception_msg  := '||Nm3flx.string('Parent not found')||';');
         Nm3ddl.append_tab_varchar('         RAISE nm3type.g_exception;');
         Nm3ddl.append_tab_varchar('      ELSIF l_found_again');
         Nm3ddl.append_tab_varchar('       THEN -- Parent details found more than once');
         Nm3ddl.append_tab_varchar('         hig.raise_ner (pi_appl               => nm3type.c_net');
         Nm3ddl.append_tab_varchar('                       ,pi_id                 => 27');
         Nm3ddl.append_tab_varchar('                       ,pi_supplementary_info => '||Nm3flx.string(l_tab_parent_type(i))
                                                                                      ||'||'||Nm3flx.string(':')||'||'
                                                                                      ||Nm3flx.string(l_tab_parent_column(i))
                                                                                      ||'||'||Nm3flx.string('=')||'||'
                                                                                      ||g_package_name||'.g_dyn_rec_ne.'||l_tab_child_column(i)
                                  );
         Nm3ddl.append_tab_varchar('                       );');
         Nm3ddl.append_tab_varchar('      END IF;');
         Nm3ddl.append_tab_varchar('   END IF;');
         Nm3ddl.append_tab_varchar('EXCEPTION');
         Nm3ddl.append_tab_varchar('   WHEN nm3type.g_exception');
         Nm3ddl.append_tab_varchar('    THEN');
         Nm3ddl.append_tab_varchar('      RAISE_APPLICATION_ERROR(nm3type.g_exception_code,nm3type.g_exception_msg);');
         Nm3ddl.append_tab_varchar('END;');

         --nm3tab_varchar.debug_tab_varchar(nm3ddl.g_tab_varchar);

         Nm3ddl.execute_tab_varchar;
         Nm3ddl.delete_tab_varchar;
      --
      EXCEPTION
         WHEN l_no_parent
          THEN
            IF NOT c_auto_create
             THEN
               Hig.raise_ner(pi_appl               => Nm3type.c_net
                            ,pi_id                 => 26
                            );
            ELSE
               --
               -- We are auto creating the parent
               --
               -- All code for auto creation needs to go here
               --
               g_dyn_rec_ne2.ne_id             := NULL;
               g_dyn_rec_ne2.ne_unique         := NULL;
               IF g_dyn_rec_ne.ne_type = 'S'
                THEN
                  g_dyn_rec_ne2.ne_type        := 'G';
               ELSE
                  g_dyn_rec_ne2.ne_type        := 'P';
               END IF;
               g_dyn_rec_ne2.ne_nt_type        := l_tab_parent_type(i);
               --
               IF Nm3net.get_nt(g_dyn_rec_ne2.ne_nt_type).nt_node_type IS NOT NULL
                THEN
                  Hig.raise_ner (pi_appl               => Nm3type.c_net
                                ,pi_id                 => 257
                                ,pi_supplementary_info => 'Parent : '||g_dyn_rec_ne2.ne_nt_type
                                );
               END IF;
               --
             
               g_dyn_rec_ne2.ne_descr          := 'Auto Created '||TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS');
               g_dyn_rec_ne2.ne_length         := NULL;
               g_dyn_rec_ne2.ne_admin_unit     := g_dyn_rec_ne.ne_admin_unit;
               g_dyn_rec_ne2.ne_start_date     := g_dyn_rec_ne.ne_start_date;
               g_dyn_rec_ne2.ne_end_date       := NULL;
               --
               l_tab_rec_ngt := Nm3net.get_gty_by_nt_type (p_nt_type => g_dyn_rec_ne2.ne_nt_type);
               --
               IF l_tab_rec_ngt.COUNT = 0
                THEN
                  Hig.raise_ner(pi_appl               => Nm3type.c_net
                               ,pi_id                 => 199
                               );
               ELSIF l_tab_rec_ngt.COUNT > 1
                THEN
                  Hig.raise_ner(pi_appl               => Nm3type.c_net
                               ,pi_id                 => 200
                               );
               ELSE
                  g_dyn_rec_ne2.ne_gty_group_type := l_tab_rec_ngt(1).ngt_group_type;
               END IF;
               --
               g_dyn_rec_ne2.ne_owner          := NULL;
               g_dyn_rec_ne2.ne_name_1         := NULL;
               g_dyn_rec_ne2.ne_name_2         := NULL;
               g_dyn_rec_ne2.ne_prefix         := NULL;
               g_dyn_rec_ne2.ne_number         := NULL;
               g_dyn_rec_ne2.ne_sub_type       := NULL;
               g_dyn_rec_ne2.ne_group          := NULL;
               g_dyn_rec_ne2.ne_no_start       := NULL;
               g_dyn_rec_ne2.ne_no_end         := NULL;
               g_dyn_rec_ne2.ne_sub_class      := NULL;
               g_dyn_rec_ne2.ne_nsg_ref        := NULL;
               g_dyn_rec_ne2.ne_version_no     := NULL;
               --
               Nm3ddl.delete_tab_varchar;
               Nm3ddl.append_tab_varchar('BEGIN',FALSE);
               Nm3ddl.append_tab_varchar('   '||g_package_name||'.g_dyn_rec_ne2.'||l_tab_parent_column(i)||' := '||g_package_name||'.g_dyn_rec_ne.'||l_tab_child_column(i)||';');
               Nm3ddl.append_tab_varchar('END;');
               Nm3ddl.execute_tab_varchar;
               Nm3ddl.delete_tab_varchar;
               --
               -- Store the current g_dyn_rec_ne in p_rec_ne for safe keeping
               p_rec_ne := g_dyn_rec_ne;
               --
               insert_any_element (p_rec_ne => g_dyn_rec_ne2);
               --
               -- g_dyn_rec_ne.ne_id is the parent ne_id so put it in g_dyn_ne_id
               g_dyn_ne_id  := g_dyn_rec_ne.ne_id;
               -- g_dyn_rec_ne.ne_gty_group_type is the gty_group_type so put it in g_dyn_val
               g_dyn_val    := g_dyn_rec_ne.ne_gty_group_type;
               -- we're carrying back on with the main one so restore g_dyn_rec_ne
               g_dyn_rec_ne := p_rec_ne;
               --
            END IF;
      END;
      --
      IF l_tab_code_control_column(i) IS NOT NULL
       THEN
         Nm3ddl.delete_tab_varchar;
         Nm3ddl.append_tab_varchar('DECLARE',FALSE);
         Nm3ddl.append_tab_varchar('--');
         Nm3ddl.append_tab_varchar('   CURSOR cs_code_val IS');
         Nm3ddl.append_tab_varchar('   SELECT TO_CHAR(NVL(TO_NUMBER('||l_tab_code_control_column(i)||'),0) + 1) new_code_val');
         Nm3ddl.append_tab_varchar('         ,ROWID ne_rowid');
         Nm3ddl.append_tab_varchar('    FROM  nm_elements_all');
         Nm3ddl.append_tab_varchar('   WHERE  ne_id = '||g_package_name||'.g_dyn_ne_id');
         Nm3ddl.append_tab_varchar('   FOR UPDATE NOWAIT;');
         Nm3ddl.append_tab_varchar('--');
         Nm3ddl.append_tab_varchar('   l_code_value VARCHAR2(30);');
         Nm3ddl.append_tab_varchar('   l_ne_rowid   ROWID;');
         Nm3ddl.append_tab_varchar('--');
         Nm3ddl.append_tab_varchar('BEGIN');
         Nm3ddl.append_tab_varchar('--');
         Nm3ddl.append_tab_varchar('   OPEN  cs_code_val;');
         Nm3ddl.append_tab_varchar('   FETCH cs_code_val INTO l_code_value, l_ne_rowid;');
         Nm3ddl.append_tab_varchar('   CLOSE cs_code_val;');
         Nm3ddl.append_tab_varchar('--');
         Nm3ddl.append_tab_varchar('   '||g_package_name||'.g_dyn_rec_ne.'||l_tab_code_control_column(i)||' := l_code_value;');
         Nm3ddl.append_tab_varchar('--');
         Nm3ddl.append_tab_varchar('   UPDATE nm_elements_all');
         Nm3ddl.append_tab_varchar('    SET   '||l_tab_code_control_column(i)||' = l_code_value');
         Nm3ddl.append_tab_varchar('   WHERE  ROWID = l_ne_rowid;');
         Nm3ddl.append_tab_varchar('--');
         Nm3ddl.append_tab_varchar('END;');
         Nm3ddl.execute_tab_varchar;
         Nm3ddl.delete_tab_varchar;
      END IF;
--
      IF   p_auto_include
        AND g_dyn_ne_id IS NOT NULL  --i.e. not optional inclusion with no parent
--       AND l_tab_auto_include(i) = 'Y'
       THEN
         DECLARE
            l_rec_nm    nm_members%ROWTYPE;
            l_rec_ne_in nm_elements%ROWTYPE;
         BEGIN
--
            l_rec_ne_in                := Nm3net.get_ne (g_dyn_ne_id);
            l_rec_nm.nm_ne_id_in       := l_rec_ne_in.ne_id;
            l_rec_nm.nm_ne_id_of       := g_dyn_rec_ne.ne_id;
            l_rec_nm.nm_type           := 'G';
            l_rec_nm.nm_obj_type       := g_dyn_val; -- NE_GTY_GROUP_TYPE of parent
            l_rec_nm.nm_begin_mp       := 0;
            l_rec_nm.nm_end_mp         := NVL(g_dyn_rec_ne.ne_length,0);
            l_rec_nm.nm_start_date     := g_dyn_rec_ne.ne_start_date;
--
            IF Nm3net.is_nt_linear (l_tab_parent_type(i)) = 'Y'
             THEN
               l_rec_nm.nm_slk         := get_new_slk (p_parent_ne_id => l_rec_nm.nm_ne_id_in
                                                      ,p_no_start_new => g_dyn_rec_ne.ne_no_start
                                                      ,p_no_end_new   => g_dyn_rec_ne.ne_no_end
                                                      ,p_length       => g_dyn_rec_ne.ne_length
                                                      ,p_sub_class    => g_dyn_rec_ne.ne_sub_class
                                                      ,p_datum_ne_id  => l_rec_nm.nm_ne_id_of
                                                      );
               l_rec_nm.nm_true        := l_rec_nm.nm_slk;
            ELSE
               l_rec_nm.nm_slk         := NULL;
               l_rec_nm.nm_true        := NULL;
            END IF;
--
            IF p_nm_cardinality IS NULL
             THEN
               l_rec_nm.nm_cardinality := get_element_cardinality (p_route_ne_id => l_rec_nm.nm_ne_id_in
                                                                  ,p_datum_ne_id => l_rec_nm.nm_ne_id_of
                                                                  );
            ELSE
               l_rec_nm.nm_cardinality := p_nm_cardinality;
            END IF;
            -- Get the admin unit from the auto inclusion parent, rather than this child record we're doing
           -- l_rec_nm.nm_admin_unit     := g_dyn_rec_ne.ne_admin_unit;
            l_rec_nm.nm_admin_unit     := l_rec_ne_in.ne_admin_unit;
            l_rec_nm.nm_end_date       := g_dyn_rec_ne.ne_end_date;
            l_rec_nm.nm_seq_no         := 0;
            l_rec_nm.nm_seg_no         := 0;
--
            l_tab_rec_nm (l_tab_rec_nm.COUNT+1) := l_rec_nm;
--
         END;
      END IF;
      --
   END LOOP;
--
   -- Create the nm_elements record and any membership records
   Nm_Debug.DEBUG('Inserting the element');

   Nm3ins.ins_ne_all (g_dyn_rec_ne);
--
   Nm_Debug.DEBUG('Creating the memberships');
   FOR i IN 1..l_tab_rec_nm.COUNT
    LOOP
      Nm3net.ins_nm (l_tab_rec_nm(i));
   END LOOP;
--
   -- g_dyn_rec_ne will now contain modified values
   p_rec_ne := g_dyn_rec_ne;
--
   Nm_Debug.proc_end(g_package_name,'insert_any_element');
--
EXCEPTION
--
   WHEN record_locked
    THEN
      Hig.raise_ner(pi_appl               => Nm3type.c_hig
                   ,pi_id                 => 33
                   );
   WHEN Nm3type.g_exception
    THEN
      RAISE_APPLICATION_ERROR(Nm3type.g_exception_code,Nm3type.g_exception_msg);
--
END insert_any_element;
--
----------------------------------------------------------------------------------
--
FUNCTION get_element_cardinality (p_route_ne_id  NUMBER
                                 ,p_datum_ne_id  NUMBER
                                 ) RETURN NUMBER IS
--
   CURSOR cs_sharing_element (c_ne_id_in NUMBER
                             ,c_ne_id_of NUMBER
                             ) IS
   SELECT nm_cardinality
         ,nm_slk
         ,nnu1.nnu_node_type
         ,nnu1.nnu_ne_id
         ,nnu1.nnu_no_node_id
         ,nnu2.nnu_node_type match_type
         ,SIGN(70-ASCII(nnu1.nnu_node_type)) * SIGN(ASCII(nnu2.nnu_node_type)-70) * nm_cardinality v_sign
    FROM  nm_members
         ,nm_node_usages nnu1
         ,nm_node_usages nnu2
         ,nm_elements
   WHERE  nm_ne_id_in          = c_ne_id_in
    AND   nm_ne_id_of         != c_ne_id_of
    AND   ne_id                = c_ne_id_of
    AND   ne_id                = nnu2.nnu_ne_id
    AND   nnu1.nnu_ne_id       = nm_ne_id_of
    AND   nnu1.nnu_no_node_id  = nnu2.nnu_no_node_id;
--
   CURSOR cs_ngt (c_ne_id NUMBER) IS
   SELECT ngt.*
    FROM  nm_elements    ne
         ,nm_group_types ngt
   WHERE  ne_id             = c_ne_id
    AND   ne_gty_group_type = ngt_group_type;
--
   l_rec_ngt       nm_group_types%ROWTYPE;
--
   l_retval        NUMBER := 1;
--
BEGIN
--
   OPEN  cs_ngt (p_route_ne_id);
   FETCH cs_ngt INTO l_rec_ngt;
   CLOSE cs_ngt;
--
   IF   l_rec_ngt.ngt_group_type IS NOT NULL
    AND l_rec_ngt.ngt_reverse_allowed = 'N'
    THEN
--
      l_retval := 1;
--
   ELSE
--
      FOR cs_rec IN cs_sharing_element (p_route_ne_id,p_datum_ne_id)
       LOOP
         IF cs_sharing_element%rowcount = 1
          THEN
            l_retval := cs_rec.v_sign;
         END IF;
         IF cs_rec.v_sign != l_retval
          THEN
            RAISE_APPLICATION_ERROR(-20001,'Unable to determine cardinality');
         END IF;
      END LOOP;
--
   END IF;
--
   RETURN l_retval;
--
END get_element_cardinality;
--
----------------------------------------------------------------------------------
--
   PROCEDURE insert_element
                (p_ne_id             IN OUT nm_elements.ne_id%TYPE
                ,p_ne_unique         IN     nm_elements.ne_unique%TYPE         DEFAULT NULL
                ,p_ne_type           IN     nm_elements.ne_type%TYPE           DEFAULT 'S'
                ,p_ne_nt_type        IN     nm_elements.ne_nt_type%TYPE        DEFAULT NULL
                ,p_ne_descr          IN     nm_elements.ne_descr%TYPE          DEFAULT NULL
                ,p_ne_length         IN     nm_elements.ne_length%TYPE         DEFAULT NULL
                ,p_ne_admin_unit     IN     nm_elements.ne_admin_unit%TYPE     DEFAULT 1
                ,p_ne_start_date     IN     nm_elements.ne_start_date%TYPE     DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                ,p_ne_end_date       IN     nm_elements.ne_end_date%TYPE       DEFAULT NULL
                ,p_ne_gty_group_type IN     nm_elements.ne_gty_group_type%TYPE DEFAULT NULL
                ,p_ne_no_start       IN     nm_elements.ne_no_start%TYPE       DEFAULT NULL
                ,p_ne_no_end         IN     nm_elements.ne_no_end%TYPE         DEFAULT NULL
                ,p_ne_owner          IN     nm_elements.ne_owner%TYPE          DEFAULT NULL
                ,p_ne_name_1         IN     nm_elements.ne_name_1%TYPE         DEFAULT NULL
                ,p_ne_name_2         IN     nm_elements.ne_name_2%TYPE         DEFAULT NULL
                ,p_ne_prefix         IN     nm_elements.ne_prefix%TYPE         DEFAULT NULL
                ,p_ne_number         IN     nm_elements.ne_number%TYPE         DEFAULT NULL
                ,p_ne_sub_type       IN     nm_elements.ne_sub_type%TYPE       DEFAULT NULL
                ,p_ne_group          IN     nm_elements.ne_group%TYPE          DEFAULT NULL
                ,p_ne_sub_class      IN     nm_elements.ne_sub_class%TYPE      DEFAULT NULL
                ,p_ne_nsg_ref        IN     nm_elements.ne_nsg_ref%TYPE        DEFAULT NULL
                ,p_ne_version_no     IN     nm_elements.ne_version_no%TYPE     DEFAULT NULL
                ,p_nm_slk            IN     nm_members.nm_slk%TYPE             DEFAULT NULL
                ,p_nm_cardinality    IN     nm_members.nm_cardinality%TYPE     DEFAULT NULL
                ,p_auto_include      IN     VARCHAR2                           DEFAULT 'Y'
                ) IS
--
  l_rec_ne     nm_elements%ROWTYPE;
--
  BEGIN
--
   Nm_Debug.proc_start(g_package_name,'insert_element');
--
   l_rec_ne.ne_id             := p_ne_id;
   l_rec_ne.ne_unique         := p_ne_unique;
--   l_rec_ne.ne_type           := 'S';  -- GJ 19-OCT-2004 surely a mistake to assume a fixed ne_type of 'S''
   l_rec_ne.ne_type           := p_ne_type;
   l_rec_ne.ne_nt_type        := p_ne_nt_type;
   l_rec_ne.ne_descr          := p_ne_descr;
   l_rec_ne.ne_length         := p_ne_length;
   l_rec_ne.ne_admin_unit     := p_ne_admin_unit;
   l_rec_ne.ne_start_date     := p_ne_start_date;
   l_rec_ne.ne_end_date       := p_ne_end_date;
   l_rec_ne.ne_gty_group_type := p_ne_gty_group_type;
   l_rec_ne.ne_owner          := p_ne_owner;
   l_rec_ne.ne_name_1         := p_ne_name_1;
   l_rec_ne.ne_name_2         := p_ne_name_2;
   l_rec_ne.ne_prefix         := p_ne_prefix;
   l_rec_ne.ne_number         := p_ne_number;
   l_rec_ne.ne_sub_type       := p_ne_sub_type;
   l_rec_ne.ne_group          := p_ne_group;
   l_rec_ne.ne_no_start       := p_ne_no_start;
   l_rec_ne.ne_no_end         := p_ne_no_end;
   l_rec_ne.ne_sub_class      := p_ne_sub_class;
   l_rec_ne.ne_nsg_ref        := p_ne_nsg_ref;
   l_rec_ne.ne_version_no     := p_ne_version_no;
--
   Nm3net.insert_any_element (p_rec_ne         => l_rec_ne
                             ,p_nm_cardinality => p_nm_cardinality
                             ,p_auto_include   => p_auto_include = 'Y'
                             );
--
   p_ne_id := l_rec_ne.ne_id;
--
   Nm_Debug.proc_end(g_package_name,'insert_element');
END insert_element;
--
-----------------------------------------------------------------------------
--
PROCEDURE grp_insert_element
                (p_ne_id             IN OUT nm_elements.ne_id%TYPE
                ,p_ne_unique         IN     nm_elements.ne_unique%TYPE         DEFAULT NULL
                ,p_ne_type           IN     nm_elements.ne_type%TYPE           DEFAULT 'S'
                ,p_ne_nt_type        IN     nm_elements.ne_nt_type%TYPE        DEFAULT NULL
                ,p_ne_descr          IN     nm_elements.ne_descr%TYPE          DEFAULT NULL
                ,p_ne_length         IN     nm_elements.ne_length%TYPE         DEFAULT NULL
                ,p_ne_admin_unit     IN     nm_elements.ne_admin_unit%TYPE     DEFAULT 1
                ,p_ne_start_date     IN     nm_elements.ne_start_date%TYPE     DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                ,p_ne_end_date       IN     nm_elements.ne_end_date%TYPE       DEFAULT NULL
                ,p_ne_gty_group_type IN     nm_elements.ne_gty_group_type%TYPE DEFAULT NULL
                ,p_ne_no_start       IN     nm_elements.ne_no_start%TYPE       DEFAULT NULL
                ,p_ne_no_end         IN     nm_elements.ne_no_end%TYPE         DEFAULT NULL
                ,p_ne_owner          IN     nm_elements.ne_owner%TYPE          DEFAULT NULL
                ,p_ne_name_1         IN     nm_elements.ne_name_1%TYPE         DEFAULT NULL
                ,p_ne_name_2         IN     nm_elements.ne_name_2%TYPE         DEFAULT NULL
                ,p_ne_prefix         IN     nm_elements.ne_prefix%TYPE         DEFAULT NULL
                ,p_ne_number         IN     nm_elements.ne_number%TYPE         DEFAULT NULL
                ,p_ne_sub_type       IN     nm_elements.ne_sub_type%TYPE       DEFAULT NULL
                ,p_ne_group          IN     nm_elements.ne_group%TYPE          DEFAULT NULL
                ,p_ne_sub_class      IN     nm_elements.ne_sub_class%TYPE      DEFAULT NULL
                ,p_ne_nsg_ref        IN     nm_elements.ne_nsg_ref%TYPE        DEFAULT NULL
                ,p_ne_version_no     IN     nm_elements.ne_version_no%TYPE     DEFAULT NULL
                ,p_nm_slk            IN     nm_members.nm_slk%TYPE             DEFAULT NULL
                ,p_nm_cardinality    IN     nm_members.nm_cardinality%TYPE     DEFAULT NULL
                ,p_auto_include      IN     VARCHAR2                           DEFAULT 'Y'
                ) IS
--
  l_rec_ne     nm_elements%ROWTYPE;
--
  BEGIN
    Nm_Debug.proc_start(g_package_name,'grp_insert_element');

--
   l_rec_ne.ne_id             := p_ne_id;
   l_rec_ne.ne_unique         := p_ne_unique;
   l_rec_ne.ne_type           := NVL(p_ne_type,'S');
   l_rec_ne.ne_nt_type        := p_ne_nt_type;
   l_rec_ne.ne_descr          := p_ne_descr;
   l_rec_ne.ne_length         := p_ne_length;
   l_rec_ne.ne_admin_unit     := p_ne_admin_unit;
   l_rec_ne.ne_start_date     := p_ne_start_date;
   l_rec_ne.ne_end_date       := p_ne_end_date;
   l_rec_ne.ne_gty_group_type := p_ne_gty_group_type;
   l_rec_ne.ne_owner          := p_ne_owner;
   l_rec_ne.ne_name_1         := p_ne_name_1;
   l_rec_ne.ne_name_2         := p_ne_name_2;
   l_rec_ne.ne_prefix         := p_ne_prefix;
   l_rec_ne.ne_number         := p_ne_number;
   l_rec_ne.ne_sub_type       := p_ne_sub_type;
   l_rec_ne.ne_group          := p_ne_group;
   l_rec_ne.ne_no_start       := p_ne_no_start;
   l_rec_ne.ne_no_end         := p_ne_no_end;
   l_rec_ne.ne_sub_class      := p_ne_sub_class;
   l_rec_ne.ne_nsg_ref        := p_ne_nsg_ref;
   l_rec_ne.ne_version_no     := p_ne_version_no;
--
   Nm3net.insert_any_element (p_rec_ne         => l_rec_ne
                             ,p_nm_cardinality => p_nm_cardinality
                             ,p_auto_include   => p_auto_include = 'Y'
                             );
--
   p_ne_id := l_rec_ne.ne_id;
--
   Nm_Debug.proc_end(g_package_name,'grp_insert_element');
END grp_insert_element;
--
-----------------------------------------------------------------------------
--
PROCEDURE gis_insert_element
                (p_ne_id             IN     nm_elements.ne_id%TYPE
                ,p_ne_unique         IN     nm_elements.ne_unique%TYPE         DEFAULT NULL
                ,p_ne_type           IN     nm_elements.ne_type%TYPE           DEFAULT 'S'
                ,p_ne_nt_type        IN     nm_elements.ne_nt_type%TYPE        DEFAULT NULL
                ,p_ne_descr          IN     nm_elements.ne_descr%TYPE          DEFAULT NULL
                ,p_ne_length         IN     nm_elements.ne_length%TYPE         DEFAULT NULL
                ,p_ne_admin_unit     IN     nm_elements.ne_admin_unit%TYPE     DEFAULT 1
                ,p_ne_start_date     IN     nm_elements.ne_start_date%TYPE     DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                ,p_ne_end_date       IN     nm_elements.ne_end_date%TYPE       DEFAULT NULL
                ,p_ne_gty_group_type IN     nm_elements.ne_gty_group_type%TYPE DEFAULT NULL
                ,p_ne_no_start       IN     nm_elements.ne_no_start%TYPE       DEFAULT NULL
                ,p_ne_no_end         IN     nm_elements.ne_no_end%TYPE         DEFAULT NULL
                ,p_ne_owner          IN     nm_elements.ne_owner%TYPE          DEFAULT NULL
                ,p_ne_name_1         IN     nm_elements.ne_name_1%TYPE         DEFAULT NULL
                ,p_ne_name_2         IN     nm_elements.ne_name_2%TYPE         DEFAULT NULL
                ,p_ne_prefix         IN     nm_elements.ne_prefix%TYPE         DEFAULT NULL
                ,p_ne_number         IN     nm_elements.ne_number%TYPE         DEFAULT NULL
                ,p_ne_sub_type       IN     nm_elements.ne_sub_type%TYPE       DEFAULT NULL
                ,p_ne_group          IN     nm_elements.ne_group%TYPE          DEFAULT NULL
                ,p_ne_sub_class      IN     nm_elements.ne_sub_class%TYPE      DEFAULT NULL
                ,p_ne_nsg_ref        IN     nm_elements.ne_nsg_ref%TYPE        DEFAULT NULL
                ,p_ne_version_no     IN     nm_elements.ne_version_no%TYPE     DEFAULT NULL
                ,p_nm_slk            IN     nm_members.nm_slk%TYPE             DEFAULT NULL
                ,p_nm_cardinality    IN     nm_members.nm_cardinality%TYPE     DEFAULT NULL
                ,p_auto_include      IN     VARCHAR2                           DEFAULT 'Y'
                ,p_ignore_check      IN     VARCHAR2                           DEFAULT 'Y'
                ) IS
--
  l_rec_ne     nm_elements%ROWTYPE;
--
  BEGIN
--
   Nm_Debug.proc_start(g_package_name,'gis_insert_element');
--
   l_rec_ne.ne_id             := p_ne_id;
   l_rec_ne.ne_unique         := p_ne_unique;
   l_rec_ne.ne_type           := 'S';
   l_rec_ne.ne_nt_type        := p_ne_nt_type;
   l_rec_ne.ne_descr          := p_ne_descr;
   l_rec_ne.ne_length         := p_ne_length;
   l_rec_ne.ne_admin_unit     := p_ne_admin_unit;
   l_rec_ne.ne_start_date     := p_ne_start_date;
   l_rec_ne.ne_end_date       := p_ne_end_date;
   l_rec_ne.ne_gty_group_type := p_ne_gty_group_type;
   l_rec_ne.ne_owner          := p_ne_owner;
   l_rec_ne.ne_name_1         := p_ne_name_1;
   l_rec_ne.ne_name_2         := p_ne_name_2;
   l_rec_ne.ne_prefix         := p_ne_prefix;
   l_rec_ne.ne_number         := p_ne_number;
   l_rec_ne.ne_sub_type       := p_ne_sub_type;
   l_rec_ne.ne_group          := p_ne_group;
   l_rec_ne.ne_no_start       := p_ne_no_start;
   l_rec_ne.ne_no_end         := p_ne_no_end;
   l_rec_ne.ne_sub_class      := p_ne_sub_class;
   l_rec_ne.ne_nsg_ref        := p_ne_nsg_ref;
   l_rec_ne.ne_version_no     := p_ne_version_no;
--
   IF   p_ignore_check = 'N'
    AND Hig.get_sysopt('CHECKROUTE') = 'Y'
    THEN
      Nm3nwval.route_check (p_ne_no_start_new  => l_rec_ne.ne_no_start
                           ,p_ne_no_end_new    => l_rec_ne.ne_no_end
                           ,p_ne_sub_class_new => l_rec_ne.ne_sub_class
                           ,p_ne_group_new     => l_rec_ne.ne_group
                           );
   END IF;
--
   Nm3net.insert_any_element (p_rec_ne         => l_rec_ne
                             ,p_nm_cardinality => p_nm_cardinality
                             ,p_auto_include   => p_auto_include = 'Y'
                             );
--
   Nm_Debug.proc_end(g_package_name,'gis_insert_element');
--
END gis_insert_element;
--
-----------------------------------------------------------------------------
--
FUNCTION is_node_valid_for_nw_type (p_node_id IN nm_nodes.no_node_id%TYPE
                                   ,p_nt_type IN NM_TYPES.nt_type%TYPE
                                   ) RETURN BOOLEAN IS
BEGIN
   RETURN is_node_valid_on_nt_type (p_node_id,p_nt_type);
END is_node_valid_for_nw_type;
--
-----------------------------------------------------------------------------
--
FUNCTION get_leg_number ( p_ne_id  nm_node_usages.nnu_ne_id%TYPE
                         ,p_node_id nm_node_usages.nnu_no_node_id%TYPE
                        ) RETURN nm_node_usages.nnu_leg_no%TYPE IS
--
-- #########################################################################################
--
--  Flawed Cursor - Full PK not provided
--
-- #########################################################################################
--
   CURSOR cs_nnu IS
   SELECT nnu_leg_no
    FROM  nm_node_usages
   WHERE  nnu_ne_id      = p_ne_id
    AND   nnu_no_node_id = p_node_id;
--
   l_tab_leg_no Nm3type.tab_number;
   l_retval     nm_node_usages.nnu_leg_no%TYPE;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'get_leg_number');
--
   OPEN  cs_nnu;
   FETCH cs_nnu BULK COLLECT INTO l_tab_leg_no;
   CLOSE cs_nnu;
--
   IF    l_tab_leg_no.COUNT = 0
    THEN
      -- No data found
      Hig.raise_ner (pi_appl               => Nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'NM_NODE_USAGES'
                    );
   ELSIF l_tab_leg_no.COUNT = 1
    THEN
      -- Only 1 -> sorted
      l_retval := l_tab_leg_no(1);
   ELSE
      -- >1 record found -> oops! - Still return the first one at present
      l_retval := l_tab_leg_no(1);
   END IF;
--
   Nm_Debug.proc_end(g_package_name,'get_leg_number');
--
   RETURN l_retval;
--
END get_leg_number;
--
-----------------------------------------------------------------------------
--
FUNCTION check_for_nt_existence ( p_nt_type  NM_TYPES.nt_type%TYPE
                        ) RETURN BOOLEAN IS
   CURSOR cs_exists (c_nt_type NM_TYPES.nt_type%TYPE) IS
   SELECT 1
    FROM  dual
   WHERE  EXISTS (SELECT 1
                   FROM  nm_elements
                  WHERE  ne_nt_type = c_nt_type
                 );
   l_dummy  BINARY_INTEGER;
   l_retval BOOLEAN;
BEGIN
   Nm_Debug.proc_start(g_package_name,'check_for_nt_existence');
   OPEN  cs_exists(p_nt_type);
   FETCH cs_exists INTO l_dummy;
   l_retval := cs_exists%FOUND;
   CLOSE cs_exists;
   Nm_Debug.proc_end(g_package_name,'check_for_nt_existence');
   RETURN l_retval;
END;
--
-----------------------------------------------------------------------------
--
FUNCTION pop_inclusion_columns(pi_parent_ne_id IN     nm_elements.ne_id%TYPE
                               ,pi_child_type  IN     NM_TYPES.nt_type%TYPE
                               ) RETURN nm_elements%ROWTYPE IS

  c_nl CONSTANT VARCHAR2(1) := CHR(10);

  l_plsql Nm3type.max_varchar2;

  l_nti_rec NM_TYPE_INCLUSION%ROWTYPE;

  l_nti_exists BOOLEAN := TRUE;

  l_dyn_ne_saved_rec nm_elements%ROWTYPE := g_dyn_rec_ne;
  l_ne_rec           nm_elements%ROWTYPE;

BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'pop_inclusion_columns');

  --make g_dyn_rec_ne empty
  g_dyn_rec_ne := l_ne_rec;

  DECLARE
    e_no_inclusion EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_no_inclusion, -20001);

  BEGIN
    l_nti_rec := Nm3net.get_nti(pi_nti_nw_parent_type => Nm3net.Get_Nt_Type(p_ne_id => pi_parent_ne_id)
                               ,pi_nti_nw_child_type  => pi_child_type);
  EXCEPTION
    WHEN e_no_inclusion
    THEN
      l_nti_exists := FALSE;

  END;

  IF l_nti_exists
  THEN
    l_plsql :=            'DECLARE'
               || c_nl || '  l_parent_ne_rec nm_elements%ROWTYPE := nm3net.get_ne(pi_ne_id => ' || pi_parent_ne_id || ');'
               || c_nl
               || c_nl || 'BEGIN'
               || c_nl || '  nm3net.g_dyn_rec_ne.' || l_nti_rec.nti_child_column || ' := l_parent_ne_rec.' || l_nti_rec.nti_parent_column || ';'
               || c_nl || 'END;';

    EXECUTE IMMEDIATE l_plsql;
  END IF;

  l_ne_rec     := g_dyn_rec_ne;
  g_dyn_rec_ne := l_dyn_ne_saved_rec;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'pop_inclusion_columns');

  RETURN l_ne_rec;

END pop_inclusion_columns;
--
-----------------------------------------------------------------------------
--
PROCEDURE insert_distance_break (pi_route_ne_id     IN     nm_members.nm_ne_id_of%TYPE
                                ,pi_start_node_id   IN     nm_nodes.no_node_id%TYPE
                                ,pi_end_node_id     IN     nm_nodes.no_node_id%TYPE
                                ,pi_start_date      IN     DATE
                                ,pi_length          IN     nm_elements.ne_length%TYPE DEFAULT 0
                                ,po_db_ne_id           OUT nm_members.nm_ne_id_in%TYPE
                                ,po_db_ne_unique       OUT nm_elements.ne_unique%TYPE
                                ) IS
--
--   l_route_rec_ne nm_elements%ROWTYPE;
--
   l_rec_ne       nm_elements%ROWTYPE;
   l_rec_nm       nm_members%ROWTYPE;
   l_route_ne_rec nm_elements%ROWTYPE;
--
   l_new_slk nm_members.nm_slk%TYPE;
   l_new_true nm_members.nm_true%TYPE;
   l_new_cardinality nm_members.nm_cardinality%TYPE;
   l_warning Nm3type.max_varchar2;
--
   l_ne_admin_unit  nm_elements.ne_admin_unit%TYPE;
   l_ne_start_date  nm_elements.ne_start_date%TYPE;
--
   l_parent_nt_type NM_TYPE_INCLUSION.nti_nw_parent_type%TYPE;
   l_parent_gty     nm_group_types.ngt_group_type%TYPE;
   l_datum_nt       NM_TYPES.nt_unique%TYPE;
--
   l_rec_nti NM_TYPE_INCLUSION%ROWTYPE;
--
   l_cur Nm3type.ref_cursor;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'insert_distance_break');
--
   -- lock the route and elements
   Nm3lock.lock_element(p_ne_id => pi_route_ne_id);

   l_route_ne_rec  := Nm3net.get_ne( pi_route_ne_id );

   l_parent_nt_type := l_route_ne_rec.ne_nt_type;
   l_parent_gty     := l_route_ne_rec.ne_gty_group_type;
   l_ne_admin_unit  := l_route_ne_rec.ne_admin_unit;
   l_ne_start_date  := l_route_ne_rec.ne_start_date;
   l_datum_nt       := get_datum_nt(pi_gty => l_parent_gty);
--
--
   po_db_ne_unique := get_db_name (l_route_ne_rec.ne_unique);
   po_db_ne_id     := get_next_ne_id;
--
-- Populate the values for inserting a NM_ELEMENTS record
--
   l_rec_ne := Nm3net.pop_inclusion_columns(pi_parent_ne_id => pi_route_ne_id
                                           ,pi_child_type   => l_datum_nt);

   l_rec_ne.ne_id         := po_db_ne_id;
   l_rec_ne.ne_unique     := po_db_ne_unique;
   l_rec_ne.ne_type       := 'D';
   l_rec_ne.ne_nt_type    := l_datum_nt;
   l_rec_ne.ne_descr      :=    'Distance break FROM '
                             || Get_Node_Name(pi_start_node_id)
                             || ' TO '
                             || Get_Node_Name(pi_end_node_id)
                             || ' ON route '
                             || l_route_ne_rec.ne_unique;
   l_rec_ne.ne_length     := pi_length;
   l_rec_ne.ne_admin_unit := l_ne_admin_unit;
   l_rec_ne.ne_start_date := GREATEST(pi_start_date,l_ne_start_date);
   l_rec_ne.ne_no_start   := pi_start_node_id;
   l_rec_ne.ne_no_end     := pi_end_node_id;
--
-- Insert a NM_ELEMENTS record
--
   ins_ne (l_rec_ne);
--
-- Populate the values for inserting a NM_MEMBERS record
--
   --get new slk and true distance
   get_node_slk_true(pi_route_ne_id        => pi_route_ne_id
                    ,pi_nw_type            => Get_Nt_Type(pi_route_ne_id)
                    ,pi_new_node_id        => pi_start_node_id
                    ,pi_new_node_type      => 'S'
                    ,pi_new_element_length => pi_length
                    ,pi_new_sub_class      => NULL
                    ,po_new_slk            => l_new_slk
                    ,po_new_true           => l_new_true
                    ,po_new_cardinality    => l_new_cardinality
                    ,po_warning            => l_warning
                    );

   l_rec_nm.nm_ne_id_in    := pi_route_ne_id;
   l_rec_nm.nm_ne_id_of    := po_db_ne_id;
   l_rec_nm.nm_begin_mp    := 0;
   l_rec_nm.nm_end_mp      := pi_length;
   l_rec_nm.nm_start_date  := l_rec_ne.ne_start_date;
   l_rec_nm.nm_slk         := Nm3net.get_node_slk(pi_route_ne_id, pi_start_node_id);
   l_rec_nm.nm_true        := l_new_true;
   l_rec_nm.nm_cardinality := 1;
   l_rec_nm.nm_admin_unit  := l_ne_admin_unit;
   l_rec_nm.nm_seq_no      := 0;
   l_rec_nm.nm_type        := 'G';
   l_rec_nm.nm_obj_type    := l_datum_nt;
--
-- Insert a NM_ELEMENTS record
--
   ins_nm (l_rec_nm);
--
   Nm_Debug.proc_end(g_package_name,'insert_distance_break');
--
END insert_distance_break;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ne (pi_ne_id IN nm_elements.ne_id%TYPE) RETURN nm_elements%ROWTYPE IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_ne');
   Nm_Debug.proc_end(g_package_name,'get_ne');
   RETURN Nm3get.get_ne (pi_ne_id             => pi_ne_id
                        ,pi_not_found_sqlcode => -20001
                        );
--
END get_ne;
--
-----------------------------------------------------------------------------
--
FUNCTION get_db_name (pi_ne_unique IN nm_elements.ne_unique%TYPE
                     ) RETURN nm_elements.ne_unique%TYPE IS
--
   c_pre    CONSTANT nm_elements.ne_unique%TYPE := 'DB-';
   c_post   CONSTANT nm_elements.ne_unique%TYPE := '-'||get_next_nm_db_seq;
   l_unq_to_use      nm_elements.ne_unique%TYPE := pi_ne_unique;
   l_unq_to_use_len  BINARY_INTEGER;
--
   l_retval nm_elements.ne_unique%TYPE;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'get_db_name');
   IF LENGTH(c_pre||l_unq_to_use||c_post) > 30
    THEN
      l_unq_to_use_len := (30 - LENGTH(c_pre||c_post));
      l_unq_to_use     := SUBSTR(pi_ne_unique,1,l_unq_to_use_len);
   END IF;
   l_retval := c_pre||l_unq_to_use||c_post;
   Nm_Debug.proc_end(g_package_name,'get_db_name');
--
   RETURN l_retval;
--
END get_db_name;
--
-----------------------------------------------------------------------------
--
FUNCTION get_next_nm_db_seq RETURN NUMBER IS
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'get_next_nm_db_seq');
   Nm_Debug.proc_end(g_package_name,'get_next_nm_db_seq');
   RETURN Nm3seq.next_nm_db_seq;
--
END get_next_nm_db_seq;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nm (pi_rec_nm IN nm_members%ROWTYPE) IS
   l_rec_nm nm_members%ROWTYPE := pi_rec_nm;
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'ins_nm');
   Nm3ins.ins_nm (l_rec_nm);
   Nm_Debug.proc_end(g_package_name,'ins_nm');
--
END ins_nm;
--
----------------------------------------------------------------------------------
--
PROCEDURE ins_ne (pi_rec_ne IN nm_elements%ROWTYPE) IS
   l_rec_ne nm_elements%ROWTYPE := pi_rec_ne;
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'ins_ne');
   Nm3ins.ins_ne_all (l_rec_ne);
   Nm_Debug.proc_end(g_package_name,'ins_ne');
--
END ins_ne;
--
----------------------------------------------------------------------------------
--
FUNCTION create_point(pi_np_grid_east  IN NM_POINTS.np_grid_east%TYPE
	                   ,pi_np_grid_north IN NM_POINTS.np_grid_north%TYPE
	                   ,pi_np_descr      IN NM_POINTS.np_descr%TYPE DEFAULT NULL
	                   ) RETURN NUMBER IS
  l_rec_np NM_POINTS%ROWTYPE;
BEGIN
   Nm_Debug.proc_start(g_package_name,'create_point');
   l_rec_np.np_id         := Nm3seq.next_np_id_seq;
   l_rec_np.np_grid_east  := pi_np_grid_east;
   l_rec_np.np_grid_north := pi_np_grid_north;
   l_rec_np.np_descr      := NVL(pi_np_descr,l_rec_np.np_id);
   Nm3ins.ins_np (l_rec_np);
   Nm_Debug.proc_end(g_package_name,'create_point');
   RETURN l_rec_np.np_id;
END;
--
----------------------------------------------------------------------------------
--
FUNCTION get_node_type( p_no_node_id nm_nodes.no_node_id%TYPE )
RETURN nm_nodes.no_node_type%TYPE IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_node_type');
   Nm_Debug.proc_end(g_package_name,'get_node_type');
   RETURN Nm3get.get_no (pi_no_node_id      => p_no_node_id
                        ,pi_raise_not_found => FALSE
                        ).no_node_type;
END get_node_type;
--
----------------------------------------------------------------------------------
--
FUNCTION get_group_exclusive_flag( p_ne_id nm_elements.ne_id%TYPE) RETURN VARCHAR2 IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_group_exclusive_flag');
   Nm_Debug.proc_end(g_package_name,'get_group_exclusive_flag');
   RETURN Nm3get.get_ngt (pi_ngt_group_type => Nm3net.get_gty_type(p_ne_id)
                         ,pi_raise_not_found => FALSE
                         ).ngt_exclusive_flag;
END;
--
----------------------------------------------------------------------------------
--
PROCEDURE get_group_units(pi_ne_id       IN  nm_elements.ne_id%TYPE
                         ,po_group_units OUT NM_UNITS.un_unit_id%TYPE
                         ,po_child_units OUT NM_UNITS.un_unit_id%TYPE
                         ) IS

  CURSOR c1(p_ne_id IN nm_elements.ne_id%TYPE) IS
    SELECT
      get_nt_units(ne_nt_type        ) group_units,
      get_nt_units(nng.nng_nt_type)    child_units
    FROM
      nm_elements     ne,
      nm_nt_groupings nng
    WHERE
      ne.ne_id = p_ne_id
    AND
      ne.ne_gty_group_type = nng.nng_group_type;


BEGIN
   Nm_Debug.proc_start(g_package_name,'get_group_units');
  OPEN c1(pi_ne_id);
    FETCH c1 INTO po_group_units, po_child_units;
    IF c1%NOTFOUND THEN
      CLOSE c1;
      RAISE_APPLICATION_ERROR( -20001, 'Group does not exist or is a group of groups');
    END IF;
  CLOSE c1;
   Nm_Debug.proc_end(g_package_name,'get_group_units');
END get_group_units;
--
----------------------------------------------------------------------------------
--
PROCEDURE get_group_units(pi_group_type  IN     nm_group_types.ngt_group_type%TYPE
                         ,po_group_units    OUT NM_UNITS.un_unit_id%TYPE
                         ,po_child_units    OUT NM_UNITS.un_unit_id%TYPE
                         ) IS

  CURSOR c_group(p_group_type IN nm_group_types.ngt_group_type%TYPE) IS
    SELECT
      get_nt_units(ngt.ngt_nt_type) group_units,
      get_nt_units(nng.nng_nt_type) child_units
    FROM
      nm_group_types  ngt,
      nm_nt_groupings nng
    WHERE
      ngt.ngt_group_type = p_group_type
    AND
      nng.nng_group_type = ngt.ngt_group_type;

BEGIN
   Nm_Debug.proc_start(g_package_name,'get_group_units');
  OPEN c_group(p_group_type => pi_group_type);
    FETCH c_group INTO po_group_units, po_child_units;
    IF c_group%NOTFOUND
    THEN
      CLOSE c_group;
      RAISE_APPLICATION_ERROR( -20001, 'Group does not exist or is a group of groups');
    END IF;
  CLOSE c_group;
   Nm_Debug.proc_end(g_package_name,'get_group_units');
END get_group_units;
--
----------------------------------------------------------------------------------
--
FUNCTION group_type_in_use(pi_group_type IN nm_group_types.ngt_group_type%TYPE
                          ) RETURN BOOLEAN IS

  CURSOR c1 IS
  SELECT 1
   FROM  dual
  WHERE EXISTS (SELECT 1
                 FROM  nm_elements
                WHERE  ne_gty_group_type = pi_group_type
               );
  l_temp PLS_INTEGER;

  l_retval BOOLEAN;
BEGIN
   Nm_Debug.proc_start(g_package_name,'group_type_in_use');
  OPEN c1;
    FETCH c1 INTO l_temp;
    l_retval := c1%FOUND;
  CLOSE c1;

   Nm_Debug.proc_end(g_package_name,'group_type_in_use');
  RETURN l_retval;
END group_type_in_use;
--
----------------------------------------------------------------------------------
--
FUNCTION route_direction(p_node_type   IN VARCHAR2
                        ,p_cardinality IN NUMBER
                        ) RETURN NUMBER IS
--
   l_retval NUMBER;
--
BEGIN
   Nm_Debug.proc_start(g_package_name,'route_direction');
   l_retval := SIGN( ASCII( p_node_type ) - 70 ) * p_cardinality;
   Nm_Debug.proc_end(g_package_name,'route_direction');
  RETURN l_retval;
END;
--
----------------------------------------------------------------------------------
--
PROCEDURE pop_temp_nodes(pi_route_id IN nm_elements.ne_id%TYPE
                                          ) IS

  CURSOR c1 IS
    SELECT
      Nm3net_O.get_node_class(pi_route_id, nnu_no_node_id) node,
      MIN(nm_seq_no) seq_no
    FROM
      nm_node_usages,
      nm_members
    WHERE
      nnu_ne_id = nm_ne_id_of
    AND
      nm_ne_id_in = pi_route_id
    GROUP BY
      nnu_no_node_id;

BEGIN
   Nm_Debug.proc_start(g_package_name,'pop_temp_nodes');
  DELETE
    NM_TEMP_NODES
  WHERE
    ntn_route_id = pi_route_id;

  FOR rec IN c1 LOOP
    INSERT INTO NM_TEMP_NODES
           (ntn_route_id
           ,ntn_node_id
           ,ntn_int_road
           ,ntn_node_type
           ,ntn_poe
           ,ntn_seq
           )
    VALUES (pi_route_id
           ,rec.node.get_node_id
           ,rec.node.get_intersecting_road
           ,rec.node.nc_node_type
           ,rec.node.get_poe
           ,rec.seq_no
           );
  END LOOP;
   Nm_Debug.proc_end(g_package_name,'pop_temp_nodes');
END;
--
----------------------------------------------------------------------------------
--
FUNCTION get_nau(pi_admin_unit IN nm_admin_units.nau_admin_unit%TYPE
                ) RETURN nm_admin_units%ROWTYPE IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_nau');
   Nm_Debug.proc_end(g_package_name,'get_nau');
   RETURN Nm3get.get_nau (pi_nau_admin_unit    => pi_admin_unit
                         ,pi_not_found_sqlcode => -20001
                         );
END get_nau;
--
----------------------------------------------------------------------------------
--
FUNCTION get_admin_unit_name(pi_admin_unit IN nm_admin_units.nau_admin_unit%TYPE
                            ) RETURN nm_admin_units.nau_name%TYPE IS
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_admin_unit_name');
   Nm_Debug.proc_end(g_package_name,'get_admin_unit_name');
   RETURN Nm3get.get_nau (pi_nau_admin_unit  => pi_admin_unit
                         ,pi_raise_not_found => FALSE
                         ).nau_name;
END;
--
----------------------------------------------------------------------------------
--
FUNCTION get_cardinality(p_ne_id_in IN nm_members.nm_ne_id_in%TYPE,
                         p_ne_id_of  IN nm_members.nm_ne_id_of%TYPE
                            ) RETURN nm_members.nm_cardinality%TYPE IS

   CURSOR c1 IS
     SELECT nm_cardinality
     FROM nm_members
     WHERE nm_ne_id_in = p_ne_id_in
     AND   nm_ne_id_of = p_ne_id_of;
   l_retval nm_members.nm_cardinality%TYPE;

BEGIN
   Nm_Debug.proc_start(g_package_name,'get_cardinality');
  OPEN c1;
  FETCH c1 INTO l_retval;
  IF c1%NOTFOUND THEN
    CLOSE c1;
    RAISE_APPLICATION_ERROR( -20001, 'Element is not part of the set (member record not found)');
  END IF;
  CLOSE c1;
   Nm_Debug.proc_end(g_package_name,'get_cardinality');
  RETURN l_retval;
END;
--
----------------------------------------------------------------------------------
--
FUNCTION check_exclusive (p_nm_ne_id_in IN nm_members.nm_ne_id_in%TYPE
                         ,p_nm_ne_id_of IN nm_members.nm_ne_id_of%TYPE
                         ,p_nm_begin_mp IN nm_members.nm_begin_mp%TYPE DEFAULT NULL
                         ,p_nm_end_mp   IN nm_members.nm_end_mp%TYPE   DEFAULT NULL
                         ) RETURN BOOLEAN IS
--
   -- get the group type of the parent and the exclusive and partial flags
   CURSOR cs_ngt ( c_nm_ne_id_in nm_members.nm_ne_id_in%TYPE ) IS
   SELECT ngt_group_type
         ,ngt_exclusive_flag
         ,ngt_partial
    FROM  nm_group_types
         ,nm_elements
   WHERE  ngt_group_type = ne_gty_group_type
     AND  ne_id = c_nm_ne_id_in;
--
   l_cs_ngt_rec cs_ngt%ROWTYPE;
--
   -- see if child exists in any other groups of the same type.
   CURSOR cs_exists_elsewhere (c_nm_ne_id_in nm_members.nm_ne_id_in%TYPE
                              ,c_nm_ne_id_of nm_members.nm_ne_id_of%TYPE
                              ,c_nm_obj_type nm_members.nm_obj_type%TYPE
                              ) IS
   SELECT 1
    FROM  dual
   WHERE EXISTS (SELECT 1
                  FROM  nm_members
                 WHERE  nm_ne_id_of  = c_nm_ne_id_of
                  AND   nm_type      = 'G'
                  AND   nm_obj_type  = c_nm_obj_type
                  AND   nm_ne_id_in != c_nm_ne_id_in
                );
--
   -- see if child exists in any other groups of the same type.
   CURSOR cs_exists_elsewhere_part (c_nm_ne_id_in nm_members.nm_ne_id_in%TYPE
                                   ,c_nm_ne_id_of nm_members.nm_ne_id_of%TYPE
                                   ,c_nm_obj_type nm_members.nm_obj_type%TYPE
                                   ,c_nm_begin_mp nm_members.nm_begin_mp%TYPE
                                   ,c_nm_end_mp   nm_members.nm_end_mp%TYPE
                                   ) IS
   SELECT 1
    FROM  dual
   WHERE EXISTS (SELECT 1
                  FROM  nm_members
                 WHERE  nm_ne_id_of  = c_nm_ne_id_of
                  AND   nm_type      = 'G'
                  AND   nm_obj_type  = c_nm_obj_type
                  AND   nm_ne_id_in != c_nm_ne_id_in
                  AND   nm_begin_mp <  c_nm_end_mp
                  AND   nm_end_mp   >   c_nm_begin_mp
                );
--
   l_dummy        BINARY_INTEGER;
--
   l_is_exclusive BOOLEAN;
--
BEGIN
   Nm_Debug.proc_start(g_package_name,'check_exclusive');
--
--    nm_debug.debug('p_nm_ne_id_in : '||p_nm_ne_id_in||' ('||nm3net.get_ne_unique(p_nm_ne_id_in)||')');
--    nm_debug.debug('p_nm_ne_id_of : '||p_nm_ne_id_of||' ('||nm3net.get_ne_unique(p_nm_ne_id_of)||')');
--    nm_debug.debug('p_nm_begin_mp : '||p_nm_begin_mp);
--    nm_debug.debug('p_nm_end_mp   : '||p_nm_end_mp);
--
    OPEN  cs_ngt(p_nm_ne_id_in);
    FETCH cs_ngt INTO l_cs_ngt_rec;
    CLOSE cs_ngt;
--
    IF l_cs_ngt_rec.ngt_exclusive_flag = 'Y'
     THEN
--
        IF l_cs_ngt_rec.ngt_partial = 'Y'
         AND (p_nm_begin_mp IS NOT NULL AND p_nm_end_mp IS NOT NULL)
         THEN
           -- If this is partial and we are not adding the entire section
--           nm_debug.debug('If this is partial and we are not adding the entire section');
--
           OPEN  cs_exists_elsewhere_part (c_nm_ne_id_in => p_nm_ne_id_in
                                          ,c_nm_ne_id_of => p_nm_ne_id_of
                                          ,c_nm_obj_type => l_cs_ngt_rec.ngt_group_type
                                          ,c_nm_begin_mp => p_nm_begin_mp
                                          ,c_nm_end_mp   => p_nm_end_mp
                                          );
           FETCH cs_exists_elsewhere_part INTO l_dummy;
           l_is_exclusive := cs_exists_elsewhere_part%NOTFOUND;
           CLOSE cs_exists_elsewhere_part;
--
        ELSE
--
           -- Not partial, or whole section being added
--           nm_debug.debug('Not partial, or whole section being added');
--           nm_debug.debug('c_nm_obj_type => '||l_cs_ngt_rec.ngt_group_type);
           OPEN  cs_exists_elsewhere (c_nm_ne_id_in => p_nm_ne_id_in
                                     ,c_nm_ne_id_of => p_nm_ne_id_of
                                     ,c_nm_obj_type => l_cs_ngt_rec.ngt_group_type
                                     );
           FETCH cs_exists_elsewhere INTO l_dummy;
           l_is_exclusive := cs_exists_elsewhere%NOTFOUND;
           CLOSE cs_exists_elsewhere;
--
        END IF;
    ELSE
       l_is_exclusive := TRUE;
    END IF;
--
   Nm_Debug.proc_end(g_package_name,'check_exclusive');
    RETURN l_is_exclusive;
--
END check_exclusive;
--
----------------------------------------------------------------------------------
--
FUNCTION get_ne_all_rowtype ( pi_ne_id nm_elements.ne_id%TYPE )
RETURN NM_ELEMENTS_ALL%ROWTYPE IS
--
--  This operates on the base table, it is not concerned with dates
--
BEGIN
   Nm_Debug.proc_start(g_package_name,'get_ne_all_rowtype');
   Nm_Debug.proc_end(g_package_name,'get_ne_all_rowtype');
   RETURN Nm3get.get_ne_all (pi_ne_id             => pi_ne_id
                            ,pi_not_found_sqlcode => -20007
                            );
END get_ne_all_rowtype;
--
----------------------------------------------------------------------------------
--
FUNCTION get_parent_type(p_nt_type             IN NM_TYPE_INCLUSION.nti_nw_child_type%TYPE
                        ,p_linear_only         IN BOOLEAN DEFAULT FALSE
                        ,p_fail_if_many_linear IN BOOLEAN DEFAULT FALSE
                        ) RETURN NM_TYPE_INCLUSION.nti_nw_parent_type%TYPE IS
--
   CURSOR c1 (c_nt_type NM_TYPE_INCLUSION.nti_nw_child_type%TYPE) IS
   SELECT nti_nw_parent_type
         ,nt_linear
    FROM  NM_TYPE_INCLUSION
         ,NM_TYPES
   WHERE  nti_nw_child_type  = c_nt_type
    AND   nti_nw_parent_type = nt_type
   ORDER BY nti_nw_parent_type;
--
   l_retval NM_TYPE_INCLUSION.nti_nw_parent_type%TYPE := NULL;
   l_linear_auto_incl_count PLS_INTEGER := 0;
   l_linear_found BOOLEAN := FALSE;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'get_parent_type');
--
   FOR cs_rec IN c1 (p_nt_type)
    LOOP
      IF cs_rec.nt_linear = 'Y'
       THEN -- This is linear - we're deffo using this one
         -- This will become dependent on user preferred LR method
         IF l_retval IS NULL
          OR NOT l_linear_found
          THEN
            l_retval       := cs_rec.nti_nw_parent_type;
            l_linear_found := TRUE;
         END IF;
         l_linear_auto_incl_count := l_linear_auto_incl_count + 1;
      ELSIF NOT p_linear_only -- This is non-linear, we'll only use this until we get a better offer
       THEN
         IF l_retval IS NULL
          THEN
            l_retval  := cs_rec.nti_nw_parent_type;
         END IF;
      END IF;
   END LOOP;
--
   IF l_retval IS NULL
    THEN
      RAISE_APPLICATION_ERROR(-20001,'No NM_TYPE_INCLUSION records found');
   ELSIF l_linear_auto_incl_count > 1
    AND  p_fail_if_many_linear
    THEN
      Hig.raise_ner (pi_appl => Nm3type.c_net
                    ,pi_id   => 343
                    );
   END IF;
--
   Nm_Debug.proc_end(g_package_name,'get_parent_type');
   RETURN l_retval;
--
END get_parent_type;
--
-----------------------------------------------------------------------------
--
FUNCTION is_gty_reversible( p_gty IN VARCHAR2 ) RETURN VARCHAR2 IS
CURSOR c1 IS
  SELECT ngt_reverse_allowed
  FROM   nm_group_types
  WHERE  ngt_group_type = p_gty;

l_retval VARCHAR2(1);

BEGIN
   Nm_Debug.proc_start(g_package_name,'is_gty_reversible');
  OPEN c1;
  FETCH c1 INTO l_retval;
  IF c1%NOTFOUND THEN
    CLOSE c1;
    RAISE_APPLICATION_ERROR( -20004, 'GROUP TYPE does NOT exist');
  ELSE
    CLOSE c1;
  END IF;
   Nm_Debug.proc_end(g_package_name,'is_gty_reversible');
  RETURN l_retval;
END is_gty_reversible;
--
----------------------------------------------------------------------------------
--
FUNCTION get_new_slk (p_parent_ne_id IN NUMBER
                     ,p_no_start_new IN NUMBER
                     ,p_no_end_new   IN NUMBER
                     ,p_length       IN NUMBER
                     ,p_sub_class    IN nm_elements.ne_sub_class%TYPE
                     ,p_datum_ne_id  IN nm_elements.ne_id%TYPE
                     ) RETURN NUMBER IS
--
   CURSOR cs_exists (c_ne_id_in nm_members.nm_ne_id_in%TYPE
                    ,c_ne_id_of nm_members.nm_ne_id_of%TYPE
                    ,c_node_id  nm_nodes.no_node_id%TYPE
                    ) IS
   SELECT /*+ INDEX (nm_node_usages nnu_nn_fk_ind) */ 1
    FROM  nm_members
         ,nm_node_usages
   WHERE  nm_ne_id_in    =  c_ne_id_in
    AND   nm_ne_id_of    =  nnu_ne_id
    AND   nnu_no_node_id =  c_node_id
    AND   nnu_ne_id      <> NVL(c_ne_id_of, nnu_ne_id)
    AND   ROWNUM         =  1;
--
   l_parent_units NM_UNITS.un_unit_id%TYPE;
   l_child_units  NM_UNITS.un_unit_id%TYPE;
--
   l_retval       NUMBER;
--
   l_found        BOOLEAN;
   l_dummy        PLS_INTEGER;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'get_new_slk');
--
   OPEN  cs_exists (c_ne_id_in => p_parent_ne_id
                   ,c_ne_id_of => p_datum_ne_id
                   ,c_node_id  => p_no_start_new
                   );
   FETCH cs_exists INTO l_dummy;
   l_found := cs_exists%FOUND;
   CLOSE cs_exists;
   --
   IF l_found
    THEN
      -- if new element added at end of route then new SLK = SLK at start node
      l_retval := Nm3net.get_node_slk(p_parent_ne_id, p_no_start_new, p_sub_class, p_datum_ne_id);
   ELSE
      OPEN  cs_exists (c_ne_id_in => p_parent_ne_id
                      ,c_ne_id_of => p_datum_ne_id
                      ,c_node_id  => p_no_end_new
                      );
      FETCH cs_exists INTO l_dummy;
      l_found := cs_exists%FOUND;
      CLOSE cs_exists;
      IF l_found
       THEN
         -- if new element added at start of route then new SLK = SLK at end node - new element length
         l_retval := Nm3net.get_node_slk(p_parent_ne_id
                                        ,p_no_end_new
                                        ,p_sub_class
                                        ,p_datum_ne_id
                                        );
         Nm3net.get_group_units (pi_ne_id       => p_parent_ne_id
                                ,po_group_units => l_parent_units
                                ,po_child_units => l_child_units
                                );
         l_retval := l_retval - Nm3unit.convert_unit(l_child_units
                                                    ,l_parent_units
                                                    ,p_length
                                                    );
      ELSE
         l_retval := 0;
      END IF;
   END IF;
--
   Nm_Debug.proc_end(g_package_name,'get_new_slk');
--
   RETURN l_retval;
--
END get_new_slk;
--
----------------------------------------------------------------------------------
--
PROCEDURE create_members (p_ne_id		IN nm_elements.ne_id%TYPE
			 ,p_ne_nt_type		IN nm_elements.ne_nt_type%TYPE
			 ,p_ne_length		IN nm_elements.ne_length%TYPE
			 ,p_ne_admin_unit	IN nm_elements.ne_admin_unit%TYPE
			 ,p_ne_start_date	IN DATE
			 ,p_ne_end_date		IN DATE
                         ,p_ne_no_start		IN nm_elements.ne_no_start%TYPE
                         ,p_ne_no_end		IN nm_elements.ne_no_end%TYPE
                         ,p_ne_sub_class        IN nm_elements.ne_sub_class%TYPE
                         ) IS
--
  CURSOR c1 IS
    SELECT nti_parent_column,
	     nti_child_column,
           nti_code_control_column,
           nti_nw_parent_type
    FROM   NM_TYPE_INCLUSION
    WHERE  nti_nw_child_type = p_ne_nt_type
    AND    nti_auto_include = 'Y';
--
   -- get the group type of the parent and the exclusive and partial flags
   CURSOR cs_ngt ( c_nm_ne_id_in nm_members.nm_ne_id_in%TYPE ) IS
   SELECT ngt.*
    FROM  nm_group_types ngt
         ,nm_elements    ne
   WHERE  ngt_group_type = ne_gty_group_type
     AND  ne_id = c_nm_ne_id_in;
--
  l_parent_id NUMBER;
  l_rec_nm     nm_members%ROWTYPE;

BEGIN

   Nm_Debug.proc_start(g_package_name,'create_members');
    FOR irec IN c1
     LOOP
       DECLARE
          l_rec_ngt nm_group_types%ROWTYPE;
       BEGIN
--
          l_parent_id := get_parent_ne_id(p_ne_id, irec.nti_nw_parent_type);
--
          OPEN  cs_ngt (l_parent_id);
          FETCH cs_ngt INTO l_rec_ngt;
          CLOSE cs_ngt;
--
          l_rec_nm.nm_ne_id_in    := l_parent_id;
          l_rec_nm.nm_ne_id_of    := p_ne_id;
          l_rec_nm.nm_type        := 'G';
          l_rec_nm.nm_obj_type    := l_rec_ngt.ngt_group_type;
          l_rec_nm.nm_begin_mp    := 0;
          l_rec_nm.nm_end_mp      := p_ne_length;
--
          l_rec_nm.nm_start_date  := p_ne_start_date;
          l_rec_nm.nm_slk         := get_new_slk(p_parent_ne_id => l_parent_id
                                                ,p_no_start_new => p_ne_no_start
                                                ,p_no_end_new   => p_ne_no_end
                                                ,p_length       => p_ne_length
                                                ,p_sub_class    => p_ne_sub_class
                                                ,p_datum_ne_id  => p_ne_id
                                                );
          l_rec_nm.nm_cardinality := 1;
          l_rec_nm.nm_admin_unit  := p_ne_admin_unit;
          l_rec_nm.nm_end_date    := p_ne_end_date;
          l_rec_nm.nm_seq_no      := 0;
--
          ins_nm(l_rec_nm);
       END;
    END LOOP;
   Nm_Debug.proc_end(g_package_name,'create_members');

END create_members;
--
----------------------------------------------------------------------------------
--
FUNCTION is_first_on_route(p_route_ne_id IN nm_elements.ne_id%TYPE
			  ,p_no_start IN nm_elements.ne_no_start%TYPE) RETURN BOOLEAN IS
  CURSOR c_on_route IS
    SELECT s.ne_id
    FROM   nm_members m1,
	       nm_elements s
    WHERE  m1.nm_ne_id_in = p_route_ne_id
	AND    m1.nm_ne_id_of = s.ne_id
	AND    DECODE( m1.nm_cardinality, 1, s.ne_no_start, s.ne_no_end ) = p_no_start;


  CURSOR c1 IS
    SELECT 1
    FROM   nm_members,
           nm_elements
    WHERE  nm_ne_id_in = p_route_ne_id
    AND    nm_ne_id_of = ne_id
    AND    ne_no_end   = p_no_start;
--
  CURSOR c2 ( c_ne_id nm_elements.ne_id%TYPE ) IS
    SELECT 1 FROM dual
    WHERE  EXISTS ( SELECT 'x' FROM nm_elements c, nm_members m2
                        WHERE c.ne_id = m2.nm_ne_id_of
                        AND   m2.nm_ne_id_in = p_route_ne_id
                        AND   c.ne_id != c_ne_id
                        AND p_no_start = DECODE( m2.nm_cardinality, 1, c.ne_no_end, c.ne_no_start));

--
  l_dummy NUMBER(1);
--
  l_retval BOOLEAN;
  l_ne_id  nm_elements.ne_id%TYPE;
--
BEGIN
--
  Nm_Debug.proc_start(g_package_name,'is_first_on_route');

--
-- Make sure the node is on the route, and if so make sure it the first node on the element in the
-- route.
--
  OPEN c_on_route;
  FETCH c_on_route INTO l_ne_id;
  IF c_on_route%NOTFOUND THEN
    l_retval := FALSE;
    CLOSE c_on_route;
  ELSE
    CLOSE c_on_route;

    IF Nm3net.is_sub_class_used( Nm3net.get_ne_gty( p_route_ne_id ) )
    THEN
      OPEN c1;
      FETCH c1 INTO l_dummy;
      l_retval := c1%NOTFOUND;
      CLOSE c1;
    ELSE
      OPEN  c2 ( l_ne_id );
      FETCH c2 INTO l_dummy;
      l_retval := c2%NOTFOUND;
      CLOSE c2;
    END IF;
  END IF;
--
  Nm_Debug.proc_end(g_package_name,'is_first_on_route');
  RETURN l_retval;
--
END is_first_on_route;
--
----------------------------------------------------------------------------------
--
FUNCTION is_last_on_route(p_route_ne_id IN nm_elements.ne_id%TYPE
			 ,p_no_end IN nm_elements.ne_no_end%TYPE) RETURN BOOLEAN IS
  CURSOR c_on_route IS
    SELECT s.ne_id
    FROM   nm_members m1,
	       nm_elements s
    WHERE  m1.nm_ne_id_in = p_route_ne_id
	AND    m1.nm_ne_id_of = s.ne_id
	AND    DECODE( m1.nm_cardinality, 1, s.ne_no_end, s.ne_no_start ) = p_no_end;

  CURSOR c1 IS
    SELECT 1
    FROM   nm_members,
           nm_elements
    WHERE  nm_ne_id_in = p_route_ne_id
    AND    nm_ne_id_of = ne_id
    AND    ne_no_start = p_no_end;
--
  CURSOR c2 ( c_ne_id nm_elements.ne_id%TYPE ) IS
    SELECT 1 FROM dual
    WHERE  EXISTS ( SELECT 'x' FROM nm_elements c, nm_members m2
                        WHERE c.ne_id = m2.nm_ne_id_of
                        AND   m2.nm_ne_id_in = p_route_ne_id
                        AND   c.ne_id != c_ne_id
                        AND p_no_end = DECODE( m2.nm_cardinality, 1, c.ne_no_start, c.ne_no_end));

--
  l_dummy NUMBER(1);
--
  l_retval BOOLEAN;
  l_ne_id  nm_elements.ne_id%TYPE;
--
BEGIN
--
  Nm_Debug.proc_start(g_package_name,'is_last_on_route');

--
-- Make sure the node is on the route, and if so make sure it the first node on the element in the
-- route.
--
  OPEN c_on_route;
  FETCH c_on_route INTO l_ne_id;
  IF c_on_route%NOTFOUND THEN
    l_retval := FALSE;
    CLOSE c_on_route;
  ELSE
    CLOSE c_on_route;

    IF Nm3net.is_sub_class_used( Nm3net.get_ne_gty( p_route_ne_id ) )
    THEN
      OPEN c1;
      FETCH c1 INTO l_dummy;
      l_retval := c1%NOTFOUND;
      CLOSE c1;
    ELSE
      OPEN  c2 ( l_ne_id );
      FETCH c2 INTO l_dummy;
      l_retval := c2%NOTFOUND;
      CLOSE c2;
    END IF;
  END IF;
--
  Nm_Debug.proc_end(g_package_name,'is_last_on_route');
  RETURN l_retval;
--
END is_last_on_route;
--
----------------------------------------------------------------------------------
--
PROCEDURE get_admin_unit(pio_admin_unit_name	IN OUT nm_admin_units.nau_name%TYPE
			,pi_nt_type 		IN     NM_TYPES.nt_type%TYPE
			,po_admin_unit		   OUT nm_admin_units.nau_admin_unit%TYPE
                        ) IS
  CURSOR c1 IS
    SELECT nau_admin_unit
    FROM   nm_admin_units,
           NM_TYPES
    WHERE  nt_admin_type = nau_admin_type
    AND    nt_type = pi_nt_type
    AND    nau_name = pio_admin_unit_name;
--
  CURSOR c2 IS
    SELECT nau_admin_unit,
	     nau_name
    FROM   nm_admin_units,
           NM_TYPES
    WHERE  nt_admin_type = nau_admin_type
    AND    nt_type = pi_nt_type
    AND    UPPER(nau_name) = UPPER(pio_admin_unit_name);
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'get_admin_unit');
  OPEN c1; -- try exact match first as this will use index
  FETCH c1 INTO po_admin_unit;
  IF c1%NOTFOUND THEN
    OPEN c2; -- try match using upper
    FETCH c2 INTO po_admin_unit,
			pio_admin_unit_name;
    IF c2%NOTFOUND THEN
      CLOSE c1;
      CLOSE c2;
      RAISE_APPLICATION_ERROR(-20001, 'ADMIN Unit does NOT exist');
    END IF;
    CLOSE c2;
  END IF;
  CLOSE c1;
   Nm_Debug.proc_end(g_package_name,'get_admin_unit');
--
END get_admin_unit;
--
----------------------------------------------------------------------------------
--
PROCEDURE create_node(pi_no_node_id   IN NM_NODES_ALL.no_node_id%TYPE
                     ,pi_np_id        IN NM_POINTS.np_id%TYPE
                     ,pi_start_date   IN NM_NODES_ALL.no_start_date%TYPE
	                 ,pi_no_descr     IN NM_NODES_ALL.no_descr%TYPE      DEFAULT NULL
	                 ,pi_no_node_type IN NM_NODES_ALL.no_node_type%TYPE  DEFAULT NULL
                     ,pi_no_node_name IN NM_NODES_ALL.no_node_name%TYPE DEFAULT NULL
                     ,pi_no_purpose   in nm_nodes_all.no_purpose%type default null -- PT 03.06.08
	             ) IS
--
   CURSOR cs_nnt IS
   SELECT nnt_type
    FROM  NM_NODE_TYPES;
--
   l_node_type nm_nodes.no_node_type%TYPE := pi_no_node_type;
   l_dummy     nm_nodes.no_node_type%TYPE;
--
   l_node_default_name nm_nodes.no_node_name%TYPE := pi_no_node_name;
--
   l_rec_no    nm_nodes%ROWTYPE;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'create_node');
  IF pi_no_node_type IS NULL
   THEN
     --
     --  No node type is supplied - we can assume that only one node type is available
     --  get the node type
     --
     OPEN  cs_nnt;
     FETCH cs_nnt INTO l_node_type;
     --
     IF cs_nnt%NOTFOUND
      THEN
        CLOSE cs_nnt;
        RAISE_APPLICATION_ERROR(-21002, 'No node types FOUND');
     END IF;
     -- fetch again to see if too many rows
     FETCH cs_nnt INTO l_dummy;
     IF cs_nnt%FOUND
      THEN
        CLOSE cs_nnt;
        RAISE_APPLICATION_ERROR(-21001, 'No node TYPE supplied');
     END IF;
     CLOSE cs_nnt;
--
  END IF;
--
  IF l_node_default_name IS NULL THEN
     l_node_default_name := get_default_node_name( pi_no_node_id, l_node_type );
  END IF;
--
  l_rec_no.no_node_id    := pi_no_node_id;
  l_rec_no.no_node_name  := l_node_default_name;
  l_rec_no.no_start_date := pi_start_date;
  l_rec_no.no_np_id      := pi_np_id;
  l_rec_no.no_descr      := NVL(pi_no_descr,l_node_default_name);
  l_rec_no.no_node_type  := l_node_type;
  l_rec_no.no_purpose    := pi_no_purpose;  -- PT 03.06.08
--
  Nm3ins.ins_no (l_rec_no);
   Nm_Debug.proc_end(g_package_name,'create_node');
--
END create_node;
--
----------------------------------------------------------------------------------
--
FUNCTION get_default_node_name(pi_no_node_id   IN nm_nodes.no_node_id%TYPE
                              ,pi_no_node_type IN nm_nodes.no_node_type%TYPE
                              ) RETURN VARCHAR2 IS
--
   l_retval nm_nodes.no_node_name%TYPE;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'get_default_node_name');
   l_retval := LTRIM(TO_CHAR(pi_no_node_id,Nm3net.get_node_name_format(pi_no_node_type)));
   Nm_Debug.proc_end(g_package_name,'get_default_node_name');
   RETURN l_retval;
--
END get_default_node_name;
--
----------------------------------------------------------------------------------
--
PROCEDURE create_point(pi_np_id         IN NM_POINTS.np_id%TYPE
                      ,pi_np_grid_east  IN NM_POINTS.np_grid_east%TYPE
	              ,pi_np_grid_north IN NM_POINTS.np_grid_north%TYPE
	              ,pi_np_descr      IN NM_POINTS.np_descr%TYPE DEFAULT NULL
	              ) IS
--
   l_rec_np NM_POINTS%ROWTYPE;
--
BEGIN
   Nm_Debug.proc_start(g_package_name,'create_point');
--
   l_rec_np.np_id         := pi_np_id;
   l_rec_np.np_grid_east  := pi_np_grid_east;
   l_rec_np.np_grid_north := pi_np_grid_north;
   l_rec_np.np_descr      := pi_np_descr;
--
   create_point (l_rec_np);
--
   Nm_Debug.proc_end(g_package_name,'create_point');
END create_point;
--
----------------------------------------------------------------------------------
--
PROCEDURE create_point(pi_rec_np IN NM_POINTS%ROWTYPE) IS
   l_rec_np  NM_POINTS%ROWTYPE := pi_rec_np;
BEGIN
   Nm_Debug.proc_start(g_package_name,'create_point');
   Nm3ins.ins_np (l_rec_np);
   Nm_Debug.proc_end(g_package_name,'create_point');
END create_point;
--
----------------------------------------------------------------------------------
--
FUNCTION member_count(pi_ne_id IN nm_members.nm_ne_id_in%TYPE
                     ) RETURN PLS_INTEGER IS

  CURSOR c1(p_ne_id IN nm_members.nm_ne_id_in%TYPE) IS
    SELECT
      COUNT(1)
    FROM
      nm_members
    WHERE
      nm_ne_id_in = p_ne_id;

  l_retval PLS_INTEGER;

BEGIN
   Nm_Debug.proc_start(g_package_name,'member_count');
  OPEN c1(pi_ne_id);
    FETCH c1 INTO l_retval;
  CLOSE c1;

   Nm_Debug.proc_end(g_package_name,'member_count');
  RETURN l_retval;
END member_count;
--
----------------------------------------------------------------------------------
--
FUNCTION group_datum_count(pi_ne_id IN nm_members.nm_ne_id_in%TYPE
                          ) RETURN PLS_INTEGER IS

  CURSOR c1(p_ne_id IN nm_members.nm_ne_id_in%TYPE) IS
    SELECT
      COUNT(1)
    FROM
      nm_members
    WHERE
      Nm3net.get_ne_gty(nm_ne_id_of) IS NULL
    CONNECT BY
      PRIOR nm_ne_id_of =  nm_ne_id_in
    START WITH
      nm_ne_id_in = p_ne_id;

  l_ne_rec nm_elements%ROWTYPE := Nm3net.get_ne(pi_ne_id => pi_ne_id);

  l_retval PLS_INTEGER;

BEGIN
   Nm_Debug.proc_start(g_package_name,'group_datum_count');
  IF l_ne_rec.ne_type = 'P' THEN
    --group of groups so use connect by query
    OPEN c1(pi_ne_id);
      FETCH c1 INTO l_retval;
    CLOSE c1;

  ELSIF l_ne_rec.ne_type = 'G' THEN
    --group of sections so use member count
    l_retval := member_count(pi_ne_id => pi_ne_id);

  ELSE
    RAISE_APPLICATION_ERROR(-20010, 'Element supplied IS NOT a GROUP.');
  END IF;

   Nm_Debug.proc_end(g_package_name,'group_datum_count');
  RETURN l_retval;

END group_datum_count;
--
----------------------------------------------------------------------------------
FUNCTION get_type(pi_ne_id IN nm_elements.ne_id%TYPE
                 ) RETURN VARCHAR2 IS

CURSOR c1( c_ne_id nm_elements.ne_id%TYPE) IS
  SELECT ne_type, ne_nt_type, ne_gty_group_type
  FROM NM_ELEMENTS_ALL
  WHERE ne_id = c_ne_id;

l_type     NM_ELEMENTS_ALL.ne_type%TYPE;
l_nt_type  NM_ELEMENTS_ALL.ne_nt_type%TYPE;
l_gty_type NM_ELEMENTS_ALL.ne_gty_group_type%TYPE;

retval VARCHAR2(1);

BEGIN
   Nm_Debug.proc_start(g_package_name,'get_type');
  OPEN c1( pi_ne_id );
  FETCH c1 INTO l_type, l_nt_type, l_gty_type;
  IF c1%NOTFOUND THEN
    retval := 'I';
	CLOSE c1;
  ELSIF is_gty_partial( l_gty_type ) = 'Y' THEN
    retval := 'P';
  ELSE
    retval := 'G';
  END IF;
   Nm_Debug.proc_end(g_package_name,'get_type');
  RETURN retval;
END;


--
----------------------------------------------------------------------------------
--
FUNCTION is_gty_partial(pi_gty IN nm_group_types.ngt_group_type%TYPE
                 ) RETURN VARCHAR2 IS
   retval nm_group_types.ngt_partial%TYPE;
BEGIN
   Nm_Debug.proc_start(g_package_name,'is_gty_partial');
   retval := is_gty_partial(pi_gty,'Y');
   Nm_Debug.proc_end(g_package_name,'is_gty_partial');
  RETURN retval;
END is_gty_partial;
--
----------------------------------------------------------------------------------
--
FUNCTION is_gty_partial(pi_gty IN nm_group_types.ngt_group_type%TYPE,
                        pi_exception_flag IN VARCHAR2
                 ) RETURN VARCHAR2 IS

CURSOR c1( c_gty nm_group_types.ngt_group_type%TYPE) IS
  SELECT a.ngt_partial
  FROM NM_GROUP_TYPES_ALL a
  WHERE a.ngt_group_type = c_gty;
--
   retval nm_group_types.ngt_partial%TYPE;
   l_gty_found BOOLEAN;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'is_gty_partial');
  OPEN  c1( pi_gty );
  FETCH c1 INTO retval;
  l_gty_found := c1%FOUND;
  CLOSE c1;
--
  IF NOT l_gty_found
   THEN
     IF pi_exception_flag = 'Y'
      THEN
        RAISE_APPLICATION_ERROR(-20001, 'NOT a GROUP TYPE' );
     ELSE
        retval := NULL;
     END IF;
  END IF;
--
   Nm_Debug.proc_end(g_package_name,'is_gty_partial');
  RETURN retval;
--
END is_gty_partial;
--
----------------------------------------------------------------------------------
--
FUNCTION get_element_history_old(pi_ne_id IN nm_elements.ne_id%TYPE
                                ,pi_date  IN DATE
                                ) RETURN NM_ELEMENT_HISTORY.neh_operation%TYPE IS

  CURSOR c1(p_ne_id IN nm_elements.ne_id%TYPE
           ,p_date  IN DATE) IS
    SELECT
      neh.neh_operation
    FROM
      NM_ELEMENT_HISTORY neh
    WHERE
      neh.neh_ne_id_old  = p_ne_id
    AND
      neh.neh_effective_date = p_date;

  l_operation NM_ELEMENT_HISTORY.neh_operation%TYPE;

BEGIN
   Nm_Debug.proc_start(g_package_name,'get_element_history_old');
  OPEN c1(p_ne_id => pi_ne_id
         ,p_date  => pi_date);
    FETCH c1 INTO l_operation;
    IF c1%NOTFOUND
    THEN
      RAISE_APPLICATION_ERROR(-20010, 'No history record found for '
                                    || ' element' || pi_ne_id
                                    || ' on ' || TO_CHAR(pi_date, 'DD-MON-YYYY'));
    END IF;
  CLOSE c1;

   Nm_Debug.proc_end(g_package_name,'get_element_history_old');
  RETURN l_operation;
END get_element_history_old;
--
----------------------------------------------------------------------------------
--
FUNCTION get_element_history_new(pi_ne_id IN nm_elements.ne_id%TYPE
                                ,pi_date  IN DATE
                                ) RETURN NM_ELEMENT_HISTORY.neh_operation%TYPE IS

  CURSOR c1(p_ne_id IN nm_elements.ne_id%TYPE
           ,p_date  IN DATE) IS
    SELECT
      neh.neh_operation
    FROM
      NM_ELEMENT_HISTORY neh
    WHERE
      neh.neh_ne_id_new  = p_ne_id
    AND
      neh.neh_effective_date = p_date;

  l_operation NM_ELEMENT_HISTORY.neh_operation%TYPE;

BEGIN
   Nm_Debug.proc_start(g_package_name,'get_element_history_new');
  OPEN c1(p_ne_id => pi_ne_id
         ,p_date  => pi_date);
    FETCH c1 INTO l_operation;
    IF c1%NOTFOUND
    THEN
      RAISE_APPLICATION_ERROR(-20010, 'No history record found for '
                                    || ' element' || pi_ne_id
                                    || ' on ' || TO_CHAR(pi_date, 'DD-MON-YYYY'));
    END IF;
  CLOSE c1;

   Nm_Debug.proc_end(g_package_name,'get_element_history_new');
  RETURN l_operation;
END get_element_history_new;
--
----------------------------------------------------------------------------------
--
PROCEDURE get_element_history(pi_ne_id      IN  nm_elements.ne_id%TYPE
                             ,pi_date       IN  DATE
                             ,pi_old_new    IN  VARCHAR2
                             ,po_operation  OUT NM_ELEMENT_HISTORY.neh_operation%TYPE
                             ,po_op_meaning OUT HIG_CODES.hco_meaning%TYPE
                             ) IS

  l_old_new VARCHAR2(2000) := UPPER(pi_old_new);

  l_hist_op_domain VARCHAR2(2000) := 'HISTORY_OPERATION';

BEGIN
  Nm_Debug.proc_start(g_package_name,'get_element_history');

  IF l_old_new = 'OLD'
  THEN
    po_operation := get_element_history_old(pi_ne_id      => pi_ne_id
                                           ,pi_date       => pi_date);

  ELSIF l_old_new = 'NEW'
  THEN
    po_operation := get_element_history_new(pi_ne_id      => pi_ne_id
                                           ,pi_date       => pi_date);

  ELSE
    RAISE_APPLICATION_ERROR(-20011, 'Incorrect argument (pi_old_new) for PROCEDURE get_element_history - '
                                    || pi_old_new);
  END IF;

  --get meaning for operation
  Hig.valid_fk_hco(a_hco_domain	 => l_hist_op_domain
	                ,a_hco_code	   => po_operation
                  ,a_hco_meaning =>	po_op_meaning);

  Nm_Debug.proc_end(g_package_name,'get_element_history');

END get_element_history;
--
----------------------------------------------------------------------------------
--
FUNCTION get_sub_class( pi_ne_id IN NM_ELEMENTS_ALL.ne_id%TYPE
                      ) RETURN VARCHAR2 IS
BEGIN
  Nm_Debug.proc_start(g_package_name,'get_sub_class');
  Nm_Debug.proc_end(g_package_name,'get_sub_class');
  RETURN Nm3get.get_ne_all(pi_ne_id           => pi_ne_id
                          ,pi_raise_not_found => FALSE
                          ).ne_sub_class;
END get_sub_class;
--
----------------------------------------------------------------------------------
--
FUNCTION get_sub_class_seq ( pi_gty IN NM_ELEMENTS_ALL.ne_gty_group_type%TYPE,
                             pi_sub_class IN NM_ELEMENTS_ALL.ne_sub_class%TYPE
                           ) RETURN NUMBER IS

CURSOR c1 IS
  SELECT nsc_seq_no
  FROM NM_TYPE_SUBCLASS, NM_NT_GROUPINGS_ALL
  WHERE nng_group_type = pi_gty
  AND nng_nt_type = nsc_nw_type
  AND nsc_sub_class = pi_sub_class;

retval NUMBER;

BEGIN
  Nm_Debug.proc_start(g_package_name,'get_sub_class_seq');
  OPEN c1;
  FETCH c1 INTO retval;
  IF c1%NOTFOUND THEN
    retval := 99;
  END IF;
  CLOSE c1;
  Nm_Debug.proc_end(g_package_name,'get_sub_class_seq');
  RETURN retval;
END;
--
----------------------------------------------------------------------------------
--
FUNCTION is_sub_class_used( pi_gty IN nm_group_types.ngt_group_type%TYPE ) RETURN BOOLEAN IS
CURSOR c1( c_gty nm_group_types.ngt_group_type%TYPE) IS
   SELECT 1
   FROM nm_group_types, NM_TYPE_INCLUSION, NM_TYPE_SUBCLASS
   WHERE ngt_group_type = c_gty
   AND   ngt_nt_type = nti_nw_parent_type
   AND   nsc_nw_type = nti_nw_child_type;

retval   BOOLEAN;
l_record NUMBER;

BEGIN
  Nm_Debug.proc_start(g_package_name,'is_sub_class_used');
  OPEN c1( pi_gty );
  FETCH c1 INTO l_record;
  retval := c1%FOUND;
  CLOSE c1;
  Nm_Debug.proc_end(g_package_name,'is_sub_class_used');
  RETURN retval;
END;
--
----------------------------------------------------------------------------------
--
FUNCTION is_nt_inclusion( pi_nt IN NM_TYPES.nt_type%TYPE ) RETURN BOOLEAN IS
CURSOR c1 IS
  SELECT 1 FROM NM_TYPE_INCLUSION a
  WHERE  a.nti_nw_parent_type = pi_nt;

l_exists NUMBER;
retval   BOOLEAN;
BEGIN
  Nm_Debug.proc_start(g_package_name,'is_nt_inclusion');
  OPEN c1;
  FETCH c1 INTO l_exists;
  retval := c1%FOUND;
  CLOSE c1;
  Nm_Debug.proc_end(g_package_name,'is_nt_inclusion');
  RETURN retval;
END;
--
----------------------------------------------------------------------------------
--
FUNCTION decode_nt_inclusion( pi_nt IN NM_TYPES.nt_type%TYPE ) RETURN NUMBER IS
  l_retval NUMBER;
BEGIN
  Nm_Debug.proc_start(g_package_name,'decode_nt_inclusion');
  IF is_nt_inclusion( pi_nt ) THEN
    l_retval := 1;
  ELSE
    l_retval := 0;
  END IF;
  Nm_Debug.proc_end(g_package_name,'decode_nt_inclusion');
  RETURN l_retval;
END;
--
----------------------------------------------------------------------------------
--
FUNCTION get_gty_nt ( pi_gty IN nm_group_types.ngt_group_type%TYPE ) RETURN NM_TYPES.nt_type%TYPE IS
BEGIN
  Nm_Debug.proc_start(g_package_name,'get_gty_nt');
  Nm_Debug.proc_end(g_package_name,'get_gty_nt');
  RETURN Nm3get.get_ngt(pi_ngt_group_type  => pi_gty
                       ,pi_raise_not_found => FALSE
                       ).ngt_nt_type;
END get_gty_nt;
--
----------------------------------------------------------------------------------
--
FUNCTION get_parent_route_true(pi_ne_id IN nm_elements.ne_id%TYPE
                              ,pi_date  IN NM_MEMBERS_ALL.nm_start_date%TYPE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                              ) RETURN NM_MEMBERS_ALL.nm_true%TYPE IS
--
-- This procedure is used by nm0520 Inv Location History.
-- The cursor has end_date >= to the effective date so that
-- locations on the same day are shown.
-- It has to be done like this because the block in the form
-- is based on nm_members_all.
--
  CURSOR c1(p_ne_id IN nm_elements.ne_id%TYPE
           ,p_date  IN nm_members.nm_start_date%TYPE) IS
    SELECT
		  nm_true
		FROM
		  NM_MEMBERS_ALL nm
		WHERE
		  nm_ne_id_in = Nm3net.get_parent_ne_id(nm_ne_id_of
		                                       ,Nm3net.get_parent_type(Nm3net.Get_Nt_Type(nm_ne_id_of)))
		AND
		  nm_ne_id_of = p_ne_id
		AND
		  nm.nm_start_date <= p_date
		AND
		  NVL(nm_end_date,TO_DATE('99991231','YYYYMMDD')) >= p_date;

  l_retval NM_MEMBERS_ALL.nm_true%TYPE;

BEGIN
  Nm_Debug.proc_start(g_package_name,'get_parent_route_true');

  IF is_nt_inclusion_child(pi_nt => Get_Nt_Type(p_ne_id => pi_ne_id))
  THEN
    OPEN c1(p_ne_id => pi_ne_id
           ,p_date  => pi_date);
      FETCH c1 INTO l_retval;
      IF c1%NOTFOUND
      THEN
        CLOSE c1;
        RAISE_APPLICATION_ERROR(-20001, 'NM_MEMBERS_ALL record not found');
      END IF;
    CLOSE c1;
  END IF;

  Nm_Debug.proc_end(g_package_name,'get_parent_route_true');
  RETURN l_retval;
END;
--
----------------------------------------------------------------------------------
--
FUNCTION get_nti (pi_nti_nw_parent_type IN NM_TYPE_INCLUSION.nti_nw_parent_type%TYPE
                 ,pi_nti_nw_child_type  IN NM_TYPE_INCLUSION.nti_nw_child_type%TYPE
                 ) RETURN NM_TYPE_INCLUSION%ROWTYPE IS
BEGIN
--
  Nm_Debug.proc_start(g_package_name,'get_nti');
  Nm_Debug.proc_end(g_package_name,'get_nti');
  RETURN Nm3get.get_nti (pi_nti_nw_parent_type => pi_nti_nw_parent_type
                        ,pi_nti_nw_child_type  => pi_nti_nw_child_type
                        ,pi_not_found_sqlcode  => -20001
                        );
--
END get_nti;
--
----------------------------------------------------------------------------------
--
FUNCTION get_nm (pi_ne_id_in IN nm_members.nm_ne_id_in%TYPE
                ,pi_ne_id_of IN nm_members.nm_ne_id_of%TYPE
                ,pi_begin_mp IN nm_members.nm_begin_mp%TYPE
                ) RETURN nm_members%ROWTYPE IS
--
   CURSOR cs_nm (p_in    nm_members.nm_ne_id_in%TYPE
                ,p_of    nm_members.nm_ne_id_of%TYPE
                ,p_begin nm_members.nm_begin_mp%TYPE
                ) IS
   SELECT *
    FROM  nm_members
   WHERE  nm_ne_id_in = p_in
    AND   nm_ne_id_of = p_of
    AND   nm_begin_mp = p_begin;
--
   l_rec_nm nm_members%ROWTYPE;
--
BEGIN
--
  Nm_Debug.proc_start(g_package_name,'get_nm');
   OPEN  cs_nm (pi_ne_id_in,pi_ne_id_of,pi_begin_mp);
   FETCH cs_nm INTO l_rec_nm;
   IF cs_nm%NOTFOUND
    THEN
      CLOSE cs_nm;
      RAISE_APPLICATION_ERROR(-20001,'NM_MEMBERS record not found '
                                     ||pi_ne_id_in
                                     ||':'
                                     ||pi_ne_id_of
                                     ||':'
                                     ||pi_begin_mp
                             );
   END IF;
   CLOSE cs_nm;
--
  Nm_Debug.proc_end(g_package_name,'get_nm');
   RETURN l_rec_nm;
--
END get_nm;
--
----------------------------------------------------------------------------------
--
FUNCTION route_has_true(pi_route IN nm_elements.ne_id%TYPE
                       ) RETURN BOOLEAN IS

  CURSOR c1(p_route nm_elements.ne_id%TYPE) IS
    SELECT
      1
    FROM
      nm_members
    WHERE
      nm_ne_id_in = p_route
    AND
      nm_true IS NULL;

  l_dummy PLS_INTEGER;
  l_retval BOOLEAN;

BEGIN
  Nm_Debug.proc_start(g_package_name,'route_has_true');
  OPEN c1(p_route => pi_route);
    FETCH c1 INTO l_dummy;
    l_retval := c1%NOTFOUND;
  CLOSE c1;

  Nm_Debug.proc_end(g_package_name,'route_has_true');
  RETURN l_retval;
END route_has_true;
--
----------------------------------------------------------------------------------
--
FUNCTION get_min_slk(pi_ne_id IN nm_elements.ne_id%TYPE
                    ) RETURN nm_members.nm_slk%TYPE IS

  CURSOR c1(p_ne_id IN nm_elements.ne_id%TYPE) IS
    SELECT
      MIN(nm_slk)
    FROM
      nm_members
    WHERE
      nm_ne_id_in = p_ne_id;

  l_retval nm_members.nm_slk%TYPE;

BEGIN
  Nm_Debug.proc_start(g_package_name,'get_min_slk');
  OPEN c1(p_ne_id        => pi_ne_id);
    FETCH c1 INTO l_retval;
  CLOSE c1;

  Nm_Debug.proc_end(g_package_name,'get_min_slk');
  RETURN l_retval;
END get_min_slk;
--
----------------------------------------------------------------------------------
--
FUNCTION is_pop_unique( pi_nt IN NM_TYPES.nt_type%TYPE ) RETURN BOOLEAN IS
CURSOR c1( c_nt NM_TYPES.nt_type%TYPE ) IS
  SELECT nt_pop_unique
  FROM NM_TYPES
  WHERE nt_type = c_nt;
l_pop NM_TYPES.nt_pop_unique%TYPE;

BEGIN
  Nm_Debug.proc_start(g_package_name,'is_pop_unique');
  OPEN c1( pi_nt);
  FETCH c1 INTO l_pop;
  CLOSE c1;
  Nm_Debug.proc_end(g_package_name,'is_pop_unique');
  RETURN (l_pop = 'Y');
END is_pop_unique;
--
----------------------------------------------------------------------------------
--
FUNCTION is_node_poe (pi_route_id nm_elements.ne_id%TYPE
                     ,pi_node_id nm_elements.ne_no_start%TYPE
                     ) RETURN BOOLEAN IS
  -- returns true if a POE exists at the node on the route
   l_node_class nm_node_class;
   l_poe        NUMBER;
--
BEGIN
--
  Nm_Debug.proc_start(g_package_name,'is_node_poe');
   l_node_class := Nm3net_O.get_node_class(pi_route_id,pi_node_id);
--
   l_poe := l_node_class.get_poe;
  Nm_Debug.proc_end(g_package_name,'is_node_poe');
   RETURN (l_poe != 0);
--
END is_node_poe;
--
------------------------------------------------------------------------------------------------
--
FUNCTION is_node_poe (p_route_ne_id IN NUMBER
                     ,p_ne_id_1     IN NUMBER
                     ,p_ne_id_2     IN NUMBER
                     ) RETURN BOOLEAN IS
--
--returns the POE gap or overlap at the boundary between two elements. Overlap is +ve
--
   l_retval      BOOLEAN := FALSE;
--
   l_node_id     nm_node_usages.nnu_no_node_id%TYPE := get_element_shared_node(p_ne_id_1,p_ne_id_2);
--
BEGIN
--
  Nm_Debug.proc_start(g_package_name,'is_node_poe');
  IF l_node_id IS NOT NULL
   THEN
     l_retval := is_node_poe (p_route_ne_id, l_node_id);
  END IF;
--
  Nm_Debug.proc_end(g_package_name,'is_node_poe');
  RETURN l_retval;
--
END is_node_poe;
--
----------------------------------------------------------------------------------
--
FUNCTION get_no(pi_node_id IN nm_nodes.no_node_id%TYPE
               ) RETURN nm_nodes%ROWTYPE IS
BEGIN
  Nm_Debug.proc_start(g_package_name,'get_no');
  Nm_Debug.proc_end(g_package_name,'get_no');
  RETURN Nm3get.get_no(pi_no_node_id        => pi_node_id
                      ,pi_not_found_sqlcode => -20005
                      );
END get_no;
--
----------------------------------------------------------------------------------
--
FUNCTION get_point_node_type(pi_route   IN nm_elements.ne_id%TYPE
                            ,pi_node_id IN nm_nodes.no_node_id%TYPE
                            ) RETURN nm_node_usages.nnu_node_type%TYPE IS

  CURSOR c1(p_route   IN nm_elements.ne_id%TYPE
           ,p_node_id IN nm_nodes.no_node_id%TYPE
           ,p_type    IN nm_node_usages.nnu_node_type%TYPE
           ) IS
    SELECT
      p_type
    FROM
      nm_members     nm,
      nm_node_usages nnu
    WHERE
      nm.nm_ne_id_in = p_route
    AND
      nm.nm_ne_id_of = nnu.nnu_ne_id
    AND
      nnu_no_node_id = p_node_id
    AND
      nnu_node_type = p_type;

  l_retval nm_node_usages.nnu_node_type%TYPE;

BEGIN
  Nm_Debug.proc_start(g_package_name,'get_point_node_type');
  OPEN c1(p_route   => pi_route
         ,p_node_id => pi_node_id
         ,p_type    => 'S');
    FETCH c1 INTO l_retval;
    IF c1%NOTFOUND
    THEN
      CLOSE c1;
      OPEN c1(p_route   => pi_route
             ,p_node_id => pi_node_id
             ,p_type    => 'E');
        FETCH c1 INTO l_retval;
    END IF;
  CLOSE c1;

  Nm_Debug.proc_end(g_package_name,'get_point_node_type');
  RETURN l_retval;
END;
--
----------------------------------------------------------------------------------
--
FUNCTION nt_valid_in_group(pi_nt_type IN nm_nt_groupings.nng_nt_type%TYPE
                          ,pi_gty     IN nm_nt_groupings.nng_group_type%TYPE
                          )RETURN BOOLEAN IS

  CURSOR c_nng(p_nt_type nm_nt_groupings.nng_nt_type%TYPE
              ,p_gty     nm_nt_groupings.nng_group_type%TYPE) IS
    SELECT
      1
    FROM
      nm_nt_groupings
    WHERE
      nng_nt_type = p_nt_type
    AND
      nng_group_type = p_gty;

  l_dummy PLS_INTEGER;

  l_retval BOOLEAN := FALSE;

BEGIN
  Nm_Debug.proc_start(g_package_name,'nt_valid_in_group');
  OPEN c_nng(p_nt_type => pi_nt_type
            ,p_gty     => pi_gty);
    FETCH c_nng INTO l_dummy;
    l_retval := c_nng%FOUND;
  CLOSE c_nng;

  Nm_Debug.proc_end(g_package_name,'nt_valid_in_group');
  RETURN l_retval;
END;
--
----------------------------------------------------------------------------------
--
FUNCTION is_nt_inclusion_child( pi_nt IN NM_TYPES.nt_type%TYPE ) RETURN BOOLEAN IS
CURSOR c1(p_nt NM_TYPES.nt_type%TYPE) IS
  SELECT 1 FROM NM_TYPE_INCLUSION a
  WHERE  a.nti_nw_child_type = p_nt;

l_exists NUMBER;
retval   BOOLEAN;
BEGIN
  Nm_Debug.proc_start(g_package_name,'is_nt_inclusion_child');
  OPEN c1(p_nt => pi_nt);
  FETCH c1 INTO l_exists;
  retval := c1%FOUND;
  CLOSE c1;
  Nm_Debug.proc_end(g_package_name,'is_nt_inclusion_child');
  RETURN retval;
END;
--
----------------------------------------------------------------------------------
--
FUNCTION datum_will_overlap_existing(pi_route          IN nm_elements.ne_id%TYPE
                                    ,pi_new_start_node IN nm_nodes.no_node_id%TYPE
                                    ,pi_new_end_node   IN nm_nodes.no_node_id%TYPE
                                    ) RETURN BOOLEAN IS

  CURSOR c_nnu(p_route     nm_elements.ne_id%TYPE
              ,p_new_node  nm_nodes.no_node_id%TYPE
              ,p_node_type nm_node_usages.nnu_node_type%TYPE) IS
    SELECT
      1
    FROM
      nm_node_usages nnu,
      nm_members     nm
    WHERE
      nm.nm_ne_id_in = p_route
    AND
      nnu.nnu_ne_id = nm.nm_ne_id_of
    AND
      nnu.nnu_no_node_id = p_new_node
    AND
      nnu.nnu_node_type = p_node_type;

  l_dummy PLS_INTEGER;

  l_retval BOOLEAN := FALSE;

BEGIN
  --check start node
  OPEN c_nnu(p_route     => pi_route
            ,p_new_node  => pi_new_start_node
            ,p_node_type => 'S');
  FETCH c_nnu INTO l_dummy;

  IF c_nnu%FOUND
  THEN
    CLOSE c_nnu;

    l_retval := TRUE;
  ELSE
    CLOSE c_nnu;

    --check end node
    OPEN c_nnu(p_route     => pi_route
              ,p_new_node  => pi_new_end_node
              ,p_node_type => 'E');
      FETCH c_nnu INTO l_dummy;
      l_retval := c_nnu%FOUND;
    CLOSE c_nnu;
  END IF;

  RETURN l_retval;

END;
--
FUNCTION get_type_sign(pi_type IN nm_node_usages.nnu_node_type%TYPE
                      ) RETURN NUMBER IS
BEGIN
--
   RETURN SIGN(ASCII(pi_type) - ASCII('F'));
--
END get_type_sign;
--
----------------------------------------------------------------------------------
--
FUNCTION element_has_children(pi_ne_id nm_elements.ne_id%TYPE
                             ) RETURN BOOLEAN IS

  CURSOR cs_nm(p_ne_id nm_elements.ne_id%TYPE) IS
    SELECT
      1
    FROM
      nm_members
    WHERE
      nm_ne_id_in = p_ne_id
    AND
      nm_type = 'G';

  l_dummy PLS_INTEGER;

  l_retval BOOLEAN;

BEGIN
  OPEN cs_nm(p_ne_id => pi_ne_id);
    FETCH cs_nm INTO l_dummy;
    l_retval := cs_nm%FOUND;
  CLOSE cs_nm;

  RETURN l_retval;
END;
--
----------------------------------------------------------------------------------
--
FUNCTION element_has_parents(pi_ne_id nm_elements.ne_id%TYPE
                            ) RETURN BOOLEAN IS

  CURSOR cs_nm(p_ne_id nm_elements.ne_id%TYPE) IS
    SELECT
      1
    FROM
      nm_members
    WHERE
      nm_ne_id_of = p_ne_id
    AND
      nm_type = 'G';

  l_dummy PLS_INTEGER;

  l_retval BOOLEAN;

BEGIN
  OPEN cs_nm(p_ne_id => pi_ne_id);
    FETCH cs_nm INTO l_dummy;
    l_retval := cs_nm%FOUND;
  CLOSE cs_nm;

  RETURN l_retval;
END;
--
----------------------------------------------------------------------------------
--
PROCEDURE get_route_and_direction(pi_datum_id     IN     nm_elements.ne_id%TYPE
                                 ,po_route_id        OUT nm_elements.ne_id%TYPE
                                 ,po_route_unique    OUT nm_elements.ne_unique%TYPE
                                 ,po_route_offset    OUT nm_members.nm_slk%TYPE
                                 ,po_direction       OUT nm_elements.ne_sub_type%TYPE
                                 ,po_dir_text        OUT HIG_CODES.hco_meaning%TYPE
                                 ) IS

  c_rte_dir_option CONSTANT hig_options.hop_id%TYPE := 'SHOWRTEDIR';

  l_datum_rec  nm_elements%ROWTYPE;
  l_parent_rec nm_elements%ROWTYPE;

  l_ntc_rec NM_TYPE_COLUMNS%ROWTYPE;

BEGIN
  l_datum_rec := get_ne_all_rowtype(pi_ne_id => pi_datum_id);

  ---------------------
  --get parent route id
  ---------------------
  DECLARE
    e_no_parent EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_no_parent, -20001);

  BEGIN
    po_route_id := get_parent_ne_id(p_child_ne_id => pi_datum_id
                                   ,p_parent_type => get_parent_type(p_nt_type => l_datum_rec.ne_nt_type));
  EXCEPTION
    WHEN e_no_parent
    THEN
      po_route_id := NULL;
  END;

  -------------------
  --get route details
  -------------------
  IF po_route_id IS NOT NULL
  THEN
    l_parent_rec := get_ne_all_rowtype(pi_ne_id => po_route_id);

    po_route_unique := l_parent_rec.ne_unique;

    --get route offset
    BEGIN
      SELECT
        nm_slk
      INTO
        po_route_offset
      FROM
        nm_members
      WHERE
        nm_ne_id_in = po_route_id
      AND
        nm_ne_id_of = pi_datum_id;
    EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
        RAISE_APPLICATION_ERROR(-20001
                               ,   'NM_MEMBERS record not found '
                                || po_route_id
                                || ':'
                                || pi_datum_id);

      WHEN TOO_MANY_ROWS
      THEN
        RAISE_APPLICATION_ERROR(-20005
                               ,   'More than one member found '
                                || po_route_id
                                || ':'
                                || pi_datum_id);

    END;

    IF Hig.get_sysopt(p_option_id => c_rte_dir_option) = 'Y'
    THEN
      ----------------------------------------------
      -- get route direction - stored in ne_sub_type
      ----------------------------------------------
      po_direction := l_parent_rec.ne_sub_type;

      Nm3flx.select_nm_type_columns(pi_nt_type     => l_parent_rec.ne_nt_type
                                   ,pi_column_name => 'NE_SUB_TYPE'
                                   ,po_rec_ntc     => l_ntc_rec);

      --get text for route dir from domain on ne_sub_type if there is one
      IF l_ntc_rec.ntc_domain IS NOT NULL
        AND po_direction IS NOT NULL
      THEN
         Hig.valid_fk_hco(a_hco_domain  => l_ntc_rec.ntc_domain
                         ,a_hco_code    => po_direction
                         ,a_hco_meaning => po_dir_text);
      END IF;
    END IF;
  END IF;

END get_route_and_direction;
--
----------------------------------------------------------------------------------
--
FUNCTION get_ne_type(pi_ne_id nm_elements.ne_id%TYPE
                    ) RETURN nm_elements.ne_type%TYPE IS

BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_ne_type');
  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_ne_type');

  RETURN Nm3net.get_ne_all_rowtype(pi_ne_id => pi_ne_id).ne_type;

END get_ne_type;
--
----------------------------------------------------------------------------------
--
FUNCTION get_single_node_true(pi_route IN nm_elements.ne_id%TYPE
                             ,pi_node  IN nm_nodes.no_node_id%TYPE
                             ) RETURN nm_members.nm_true%TYPE IS

  CURSOR cs_node_true(p_route IN nm_elements.ne_id%TYPE
                     ,p_node  IN nm_nodes.no_node_id%TYPE) IS
    SELECT
      Nm3net.route_direction( nnu_node_type, nm_cardinality ), ne_length, nm_true, nm_begin_mp, nm_end_mp, ne_length
    FROM
      nm_node_usages,
      nm_members,
	  nm_elements
    WHERE
      nnu_no_node_id = p_node
    AND
      nm_ne_id_in = p_route
    AND
	  nm_ne_id_of = ne_id
    AND
      nm_ne_id_of = nnu_ne_id;

  l_retval nm_members.nm_true%TYPE;
  l_ne_id  nm_elements.ne_id%TYPE;
  l_dir    NUMBER;
  l_end    nm_members.nm_end_mp%TYPE;
  l_begin  nm_members.nm_begin_mp%TYPE;
  l_length nm_elements.ne_length%TYPE;

BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_single_node_true');

  OPEN cs_node_true(p_route => pi_route
                   ,p_node  => pi_node);
    FETCH cs_node_true INTO l_dir, l_ne_id, l_retval, l_begin, l_end, l_length;
  CLOSE cs_node_true;

  IF l_dir = -1 THEN
    l_retval := l_retval + NVL(l_end, l_length) - l_begin;
  END IF;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_single_node_true');

  RETURN l_retval;

END get_single_node_true;
--
----------------------------------------------------------------------------------
--
FUNCTION get_gty_by_nt_type (p_nt_type nm_group_types.ngt_nt_type%TYPE
                            ) RETURN Nm3type.tab_rec_ngt IS
--
   CURSOR cs_ngt (c_nt_type nm_group_types.ngt_nt_type%TYPE) IS
   SELECT *
    FROM  nm_group_types
   WHERE  ngt_nt_type = c_nt_type;
--
   l_retval Nm3type.tab_rec_ngt;
--
BEGIN
--
   FOR cs_rec IN cs_ngt(p_nt_type)
    LOOP
      l_retval(l_retval.COUNT+1) := cs_rec;
   END LOOP;
--
   RETURN l_retval;
--
END get_gty_by_nt_type;
--
----------------------------------------------------------------------------------
--
FUNCTION column_is_autocreate_child_col (p_child_nt_type NM_TYPE_INCLUSION.nti_nw_child_type%TYPE
                                        ,p_child_column  NM_TYPE_INCLUSION.nti_child_column%TYPE
                                        ) RETURN BOOLEAN IS
   CURSOR cs_nti IS
   SELECT 1
    FROM  NM_TYPE_INCLUSION
   WHERE  nti_nw_child_type = p_child_nt_type
    AND   nti_child_column  = p_child_column
    AND   nti_auto_create   = 'Y';
   l_retval BOOLEAN;
   l_dummy  PLS_INTEGER;
BEGIN
   OPEN  cs_nti;
   FETCH cs_nti INTO l_dummy;
   l_retval := cs_nti%FOUND;
   CLOSE cs_nti;
   RETURN l_retval;
END column_is_autocreate_child_col;
--
----------------------------------------------------------------------------------
--
FUNCTION is_column_autocreate_child_col (p_child_nt_type NM_TYPE_INCLUSION.nti_nw_child_type%TYPE
                                        ,p_child_column  NM_TYPE_INCLUSION.nti_child_column%TYPE
                                        ) RETURN VARCHAR2 IS
BEGIN
   RETURN Nm3flx.boolean_to_char(column_is_autocreate_child_col(p_child_nt_type,p_child_column));
END is_column_autocreate_child_col;
--
----------------------------------------------------------------------------------
--
FUNCTION subclass_is_used (pi_ne_id nm_elements.ne_id%TYPE) RETURN BOOLEAN IS
--
   CURSOR cs_subclass (c_nt_type nm_elements.ne_nt_type%TYPE) IS
   SELECT COUNT(1)
    FROM  NM_TYPE_SUBCLASS
   WHERE  nsc_nw_type = c_nt_type;
--
   l_dummy  PLS_INTEGER;
--
BEGIN
--
   OPEN  cs_subclass (Nm3net.Get_Nt_Type(pi_ne_id));
   FETCH cs_subclass INTO l_dummy;
   CLOSE cs_subclass;
--
   RETURN (l_dummy>=2);
--
END subclass_is_used;
--
----------------------------------------------------------------------------------
--
FUNCTION get_end_slk(p_ne_id     IN NUMBER
                    ,p_start_slk IN NUMBER
                    ,p_length    IN NUMBER
                    ) RETURN NUMBER IS

  l_p_unit NUMBER;
  l_c_unit NUMBER;

  retval   NUMBER;

BEGIN

  l_p_unit := Nm3net.get_gty_units(Nm3net.get_gty_type(p_ne_id));

  l_c_unit := Nm3net.get_nt_units(p_nt_type => Nm3net.get_datum_nt(pi_ne_id => p_ne_id));

  retval := p_start_slk + Nm3unit.convert_unit( l_c_unit, l_p_unit, p_length );


  RETURN retval;
END;

----------------------------------------------------------------------------------
--

FUNCTION get_single_ne_id (p_nt_type   IN nm_elements.ne_nt_type%TYPE
                          ,p_column    IN VARCHAR2
                          ,p_col_value IN VARCHAR2
                          ) RETURN nm_elements.ne_id%TYPE IS
--
   l_retval nm_elements.ne_id%TYPE;
   l_sql    VARCHAR2(2000);
--
BEGIN
--
   l_sql :=      'SELECT ne_id'
      ||CHR(10)||' FROM  nm_elements'
      ||CHR(10)||'WHERE  ne_nt_type = :p_nt_type'
      ||CHR(10)||' AND   '||p_column||' = :p_col_value';
--
   EXECUTE IMMEDIATE l_sql INTO l_retval USING p_nt_type, p_col_value;
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN NO_DATA_FOUND
    THEN
      Hig.raise_ner(Nm3type.c_hig,67,-20001);
   WHEN TOO_MANY_ROWS
    THEN
      Hig.raise_ner(Nm3type.c_hig,105,-20000);
--
END get_single_ne_id;
--
----------------------------------------------------------------------------------
--
FUNCTION is_node_valid_on_nt_type (pi_node_id nm_nodes.no_node_id%TYPE
                                  ,pi_nt_type NM_TYPES.nt_type%TYPE
                                  ) RETURN BOOLEAN IS
--
   CURSOR cs_check (c_node_id nm_nodes.no_node_id%TYPE
                   ,c_nt_type NM_TYPES.nt_type%TYPE
                   ) IS
   SELECT 1
    FROM  nm_nodes
         ,NM_TYPES
   WHERE  nt_type      = c_nt_type
    AND   no_node_id   = c_node_id
    AND   nt_node_type = no_node_type;
--
   CURSOR cs_ok_without_node (c_nt_type NM_TYPES.nt_type%TYPE
                             ) IS
   SELECT 1
    FROM  NM_TYPES
   WHERE  nt_type      =  c_nt_type
    AND   nt_node_type IS NULL;
--
   l_dummy  PLS_INTEGER;
--
   l_retval BOOLEAN;
--
BEGIN
--
   IF pi_node_id IS NULL
    THEN
      --
      -- If there is no node_id passed in then
      --  check to make sure that the NT_TYPE does not have a node type associated
      --
      OPEN  cs_ok_without_node (pi_nt_type);
      FETCH cs_ok_without_node INTO l_dummy;
      l_retval := cs_ok_without_node%FOUND;
      CLOSE cs_ok_without_node;
   ELSE
      --
      -- If there is a node_id passed in then make sure
      --  that the NT_TYPE has a node_type assoociated
      --  and that the node passed is of the correct type
      --
      OPEN  cs_check (pi_node_id, pi_nt_type);
      FETCH cs_check INTO l_dummy;
      l_retval := cs_check%FOUND;
      CLOSE cs_check;
   END IF;
--
   RETURN l_retval;
--
END is_node_valid_on_nt_type;
--
----------------------------------------------------------------------------------
--
FUNCTION get_sub_type (pi_obj_type IN nm_group_types.ngt_group_type%TYPE
                      ) RETURN NM_TYPES.nt_type%TYPE IS
--
   CURSOR cs_nng (c_obj_type nm_group_types.ngt_group_type%TYPE) IS
   SELECT a.nng_nt_type
    FROM  NM_NT_GROUPINGS_ALL a
   WHERE  a.nng_group_type = c_obj_type;
--
   CURSOR cs_ngr (c_obj_type nm_group_types.ngt_group_type%TYPE) IS
   SELECT ngr_child_group_type
    FROM NM_GROUP_RELATIONS_ALL
   CONNECT BY PRIOR ngr_parent_group_type = ngr_child_group_type
   START WITH ngr_parent_group_type = c_obj_type;
--
   l_tab_child_group_type Nm3type.tab_varchar4;
--
   l_retval               NM_TYPES.nt_type%TYPE;
   l_nt_type              NM_TYPES.nt_type%TYPE;
--
BEGIN
--
   OPEN  cs_ngr (pi_obj_type);
   FETCH cs_ngr
    BULK COLLECT
    INTO l_tab_child_group_type;
   CLOSE cs_ngr;
--
   IF l_tab_child_group_type.COUNT > 0
    THEN
     l_nt_type := l_tab_child_group_type(l_tab_child_group_type.COUNT);
   ELSE
     l_nt_type := pi_obj_type;
   END IF;
--
   OPEN  cs_nng (l_nt_type);
   FETCH cs_nng
    INTO l_retval;
   CLOSE cs_nng;
--
   RETURN l_retval;
--
END get_sub_type;
--
----------------------------------------------------------------------------------
--
FUNCTION get_nt_units_from_ne (p_ne_id nm_elements.ne_id%TYPE) RETURN NM_TYPES.nt_length_unit%TYPE IS
--
   CURSOR cs_units (c_ne_id nm_elements.ne_id%TYPE) IS
   SELECT nt_length_unit
    FROM  NM_ELEMENTS_ALL
         ,NM_TYPES
   WHERE  ne_id      = c_ne_id
    AND   ne_nt_type = nt_type;
--
   l_found  BOOLEAN;
   l_retval NM_TYPES.nt_length_unit%TYPE;
--
BEGIN
--
   OPEN  cs_units (p_ne_id);
   FETCH cs_units
    INTO l_retval;
   l_found := cs_units%FOUND;
   CLOSE cs_units;
--
   IF NOT l_found
    THEN
      Hig.raise_ner (pi_appl               => Nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'nm_elements.ne_id='||p_ne_id
                    );
   END IF;
--
   RETURN l_retval;
--
END get_nt_units_from_ne;
--
----------------------------------------------------------------------------------
--
FUNCTION child_autoincluded_in_parent(pi_nti_nw_parent_type   IN NM_TYPE_INCLUSION.nti_nw_parent_type%TYPE
                                     ,pi_nti_nw_child_type    IN NM_TYPE_INCLUSION.nti_nw_child_type%TYPE
                                     ) RETURN VARCHAR2 IS

  ex_not_found          EXCEPTION ;
  PRAGMA EXCEPTION_INIT(ex_not_found, -20020);

  v_nti_record    NM_TYPE_INCLUSION%ROWTYPE;
  l_inclusion     VARCHAR2(1) DEFAULT 'N';

BEGIN

   Nm_Debug.proc_start(g_package_name,'child_autoincluded_in_parent');

    -----------------------------------------------------------
    -- See if the parent/child network types are autoincluded
    -----------------------------------------------------------
    BEGIN
       v_nti_record := Nm3get.get_nti (pi_nti_nw_parent_type => pi_nti_nw_parent_type
                                      ,pi_nti_nw_child_type  => pi_nti_nw_child_type
                                      ,pi_raise_not_found    => TRUE
                                      ,pi_not_found_sqlcode  => -20020);
--
       -------------------------------------------------------------------------------------------------
       -- Assumption is that if a record was found we've got to here - so set autoinclusion flag to TRUE
       -------------------------------------------------------------------------------------------------
       l_inclusion := 'Y';
--
    EXCEPTION
      WHEN ex_not_found THEN
        l_inclusion := 'N';
    END;

    RETURN (l_inclusion);

   Nm_Debug.proc_end(g_package_name,'child_autoincluded_in_parent');

END child_autoincluded_in_parent;
--
----------------------------------------------------------------------------------
--
FUNCTION inclusion_in_use RETURN BOOLEAN IS

  l_retval BOOLEAN;

BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'inclusion_in_use');

  DECLARE
    l_dummy PLS_INTEGER;

  BEGIN
    SELECT
      1
    INTO
      l_dummy
    FROM
      NM_TYPE_INCLUSION
    WHERE
      ROWNUM = 1;

    l_retval := TRUE;

  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
      l_retval := FALSE;

  END;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'inclusion_in_use');

  RETURN l_retval;

END inclusion_in_use;
--
----------------------------------------------------------------------------------
--
FUNCTION get_point_for_coords (pi_np_grid_east   IN NM_POINTS.np_grid_east%TYPE
                              ,pi_np_grid_north   IN NM_POINTS.np_grid_north%TYPE
                              ) RETURN NM_POINTS%ROWTYPE IS


  CURSOR c1 IS
  SELECT *
  FROM   NM_POINTS
  WHERE  np_grid_east  = pi_np_grid_east
  AND    np_grid_north = pi_np_grid_north;

  v_np_row NM_POINTS%ROWTYPE;

BEGIN

  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_point_for_coords');


  OPEN c1;
  FETCH c1 INTO v_np_row;
  CLOSE c1;

  RETURN(v_np_row);

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_point_for_coords');
END;
--
----------------------------------------------------------------------------------
--
FUNCTION get_node_at_point (
                            pi_no_np_id     IN nm_nodes.no_np_id%TYPE
                           ,pi_no_node_type IN nm_nodes.no_node_type%TYPE
						   ,pi_as_at_date   IN DATE DEFAULT NULL
						   ) RETURN nm_nodes%ROWTYPE IS


  CURSOR c1 IS
  SELECT *
  FROM   nm_nodes
  WHERE  no_np_id = pi_no_np_id
  AND    no_node_type = pi_no_node_type
  AND    (no_start_date <= pi_as_at_date OR pi_as_at_date IS NULL)  
  AND    no_end_date IS NULL;

  l_no_row  nm_nodes%ROWTYPE;

BEGIN

  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_node_at_point');

  OPEN c1;
  FETCH c1 INTO l_no_row;
  CLOSE c1;

  RETURN (l_no_row);

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_node_at_point');

END get_node_at_point;
--
----------------------------------------------------------------------------------
--
PROCEDURE get_id_and_unique_node_name(pi_no_node_type     IN      nm_nodes.no_node_type%TYPE
                                     ,po_no_node_id       IN OUT  nm_nodes.no_node_id%TYPE
                                     ,po_no_node_name     IN OUT  nm_nodes.no_node_name%TYPE) IS                 

 l_unique_node_name_derived BOOLEAN := FALSE;

BEGIN

 LOOP 

   po_no_node_id    := Nm3net.get_next_node_id;
   po_no_node_name  := Nm3net.make_node_name(pi_no_node_type,po_no_node_id);
dbms_output.put_line('trying with '||po_no_node_name);            
     
   IF po_no_node_name IS NULL OR get_node_id(p_no_name      => po_no_node_name
                                            ,p_no_node_type => pi_no_node_type) IS NULL THEN 
        
     l_unique_node_name_derived := TRUE;
  
  END IF;
              
  EXIT WHEN l_unique_node_name_derived = TRUE;

  END LOOP;

END get_id_and_unique_node_name;
--
----------------------------------------------------------------------------------
--
PROCEDURE create_or_reuse_point_and_node(
                                         pi_np_grid_east     IN      NM_POINTS.np_grid_east%TYPE
                                        ,pi_np_grid_north    IN      NM_POINTS.np_grid_north%TYPE
										,pi_no_start_date    IN      nm_nodes.no_start_date%TYPE     DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
										,pi_no_node_type     IN      nm_nodes.no_node_type%TYPE
										,pi_node_descr       IN      nm_nodes.no_descr%TYPE          DEFAULT 'Auto-created'
										,po_no_node_id       IN OUT  nm_nodes.no_node_id%TYPE
										,po_np_id            IN OUT  NM_POINTS.np_id%TYPE
										) IS

  v_np_row    NM_POINTS%ROWTYPE;
  v_no_row    nm_nodes%ROWTYPE;

  l_no_node_name nm_nodes.no_node_name%TYPE;
 
BEGIN

--nm_debug.debug_on;

  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'create_or_reuse_point_and_node');


     po_no_node_id := NULL;
	 po_np_id      := NULL;

     ---------------------------------------------
	 -- Look at the eastings and northings and see
	 -- if there is a point that can be re-used
     ---------------------------------------------
     v_np_row := Nm3net.get_point_for_coords (
                                              pi_np_grid_east    => pi_np_grid_east
                                             ,pi_np_grid_north   => pi_np_grid_north
                                             );

--nm_debug.debug('just ran get_point_for_coords and np_id = '||NVL(to_char(v_np_row.np_id),'NULL'));

	 -------------------------------------
	 -- If there is not an existing point
	 -- then createa new one
	 -------------------------------------
     IF v_np_row.np_id IS NULL THEN
          po_np_id := Nm3net.create_point(pi_np_grid_east  => pi_np_grid_east
                                         ,pi_np_grid_north => pi_np_grid_north);

--nm_debug.debug('created point '||to_char(po_np_id));

     ELSE

          po_np_id := v_np_row.np_id;

          -----------------------------------------
	      -- Since this point already exists
		  -- see if there is a node at this point
		  -- of the given type that we can also use
		  -----------------------------------------
          v_no_row := Nm3net.get_node_at_point (
                                                pi_no_np_id     => po_np_id
                                               ,pi_no_node_type => pi_no_node_type
											   ,pi_as_at_date   => pi_no_start_date 
                                               );
          ---------------------------------------------------------------------
		  -- Set the po_no_node_id to be the node id returned - null if no node
          ---------------------------------------------------------------------
          po_no_node_id := v_no_row.no_node_id;

     END IF;


     ---------------------------------
	 -- so if no node, then create one
     ---------------------------------

     IF po_no_node_id IS NULL THEN

            -----------------------------------------
            -- Grab next node id and unique node name
            -----------------------------------------
            get_id_and_unique_node_name(pi_no_node_type   => pi_no_node_type
                                       ,po_no_node_id     => po_no_node_id
                                       ,po_no_node_name   => l_no_node_name);            
           

--dbms_output.put_line('having to create a node - assigning node id '||to_char(po_no_node_id));
            --------------------------------------------
            -- Create node and associate with our point
            --------------------------------------------
            Nm3net.create_node( pi_no_node_id   => po_no_node_id
                               ,pi_np_id        => po_np_id
                               ,pi_start_date   => pi_no_start_date
                               ,pi_no_descr     => pi_node_descr
                               ,pi_no_node_type => pi_no_node_type
                               ,pi_no_node_name => l_no_node_name
                               ,pi_no_purpose   => null             -- PT 03.06.08
                               );

     END IF;

--nm_debug.debug('Created node');


  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'create_or_reuse_point_and_node');


END create_or_reuse_point_and_node;
--
----------------------------------------------------------------------------------
--
FUNCTION get_min_element_length_allowed(pi_nt_type IN NM_TYPES.nt_type%TYPE) RETURN NUMBER IS

BEGIN

 RETURN(2 * Nm3unit.get_tol_from_unit_mask( Nm3net.get_nt(pi_nt_type).nt_length_unit ));

END get_min_element_length_allowed;
--
----------------------------------------------------------------------------------
--
FUNCTION element_is_a_datum(pi_ne_type IN     nm_elements.ne_type%TYPE) RETURN BOOLEAN IS

BEGIN
  RETURN(pi_ne_type = g_ne_type_datum);
END element_is_a_datum;
--
--
FUNCTION element_is_a_datum(pi_ne_id   IN     nm_elements.ne_id%TYPE) RETURN BOOLEAN IS
 l_ne_rec nm_elements%ROWTYPE := Nm3get.get_ne_all(pi_ne_id);
BEGIN
  RETURN( element_is_a_datum(pi_ne_type => l_ne_rec.ne_type) );
END element_is_a_datum;
--
----------------------------------------------------------------------------------
--
FUNCTION element_is_a_group(pi_ne_type IN     nm_elements.ne_type%TYPE) RETURN BOOLEAN IS

BEGIN
  RETURN(pi_ne_type = g_ne_type_group);
END element_is_a_group;
--
--
FUNCTION element_is_a_group(pi_ne_id   IN     nm_elements.ne_id%TYPE) RETURN BOOLEAN IS
 l_ne_rec nm_elements%ROWTYPE := Nm3get.get_ne_all(pi_ne_id);
BEGIN
  RETURN( element_is_a_group(pi_ne_type => l_ne_rec.ne_type) );
END element_is_a_group;
--
----------------------------------------------------------------------------------
--
FUNCTION element_is_a_group_of_groups(pi_ne_type IN     nm_elements.ne_type%TYPE) RETURN BOOLEAN IS

BEGIN
  RETURN(pi_ne_type = g_ne_type_group_of_groups);
END element_is_a_group_of_groups;
--
--
FUNCTION element_is_a_group_of_groups(pi_ne_id   IN     nm_elements.ne_id%TYPE) RETURN BOOLEAN IS
 l_ne_rec nm_elements%ROWTYPE := Nm3get.get_ne_all(pi_ne_id);
BEGIN
  RETURN( element_is_a_group_of_groups(pi_ne_type => l_ne_rec.ne_type) );
END element_is_a_group_of_groups;
--
----------------------------------------------------------------------------------
--
FUNCTION element_is_a_distance_break(pi_ne_type IN     nm_elements.ne_type%TYPE) RETURN BOOLEAN IS

BEGIN
  RETURN(pi_ne_type = g_ne_type_distance_break);
END element_is_a_distance_break;
--
--
FUNCTION element_is_a_distance_break(pi_ne_id   IN     nm_elements.ne_id%TYPE) RETURN BOOLEAN IS
 l_ne_rec nm_elements%ROWTYPE := Nm3get.get_ne_all(pi_ne_id);
BEGIN
  RETURN( element_is_a_distance_break(pi_ne_type => l_ne_rec.ne_type) );
END element_is_a_distance_break;
--
----------------------------------------------------------------------------------
--
FUNCTION ne_unique_could_be_derived(pi_nt_type IN NM_TYPES.nt_type%TYPE) RETURN BOOLEAN IS

  CURSOR c1 IS
  SELECT 'Y'
  FROM   NM_TYPES nt
        ,NM_TYPE_COLUMNS ntc
  WHERE  nt.nt_type =  pi_nt_type
  AND    nt.nt_pop_unique = 'Y'
  AND    nt.nt_type = ntc.ntc_nt_type
  AND    ntc.ntc_unique_seq IS NOT NULL
  AND    ntc.ntc_seq_name IS NOT NULL;

  v_dummy VARCHAR2(1) := NULL;

BEGIN

  OPEN c1;
  FETCH c1 INTO v_dummy;
  CLOSE c1;

  IF v_dummy IS NOT NULL THEN
    RETURN(TRUE);
  ELSE
    RETURN(FALSE);
  END IF;

END ne_unique_could_be_derived;
--
----------------------------------------------------------------------------------
--
-- for ATLAS moved this into nm3net
--
FUNCTION get_latest_member_date(pi_ne_id IN nm_elements.ne_id%TYPE) RETURN DATE IS

 CURSOR c1 IS
 SELECT nm_start_date
 FROM   NM_MEMBERS_ALL
 WHERE  nm_ne_id_of = pi_ne_id
 AND    nm_end_date IS NULL
 UNION ALL
 SELECT nm_start_date
 FROM   NM_MEMBERS_ALL
 WHERE  nm_ne_id_in = pi_ne_id
 AND    nm_end_date IS NULL
 ORDER BY 1 DESC;

 l_retval DATE;


BEGIN

 OPEN c1;
 FETCH c1 INTO l_retval;
 CLOSE c1;

 RETURN(l_retval);

END get_latest_member_date;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION element_has_future_dated_membs (pi_ne_id          IN nm_elements.ne_id%TYPE
                                        ,pi_effective_date IN DATE) RETURN BOOLEAN IS



BEGIN

 IF NVL(get_latest_member_date(pi_ne_id => pi_ne_id),pi_effective_date) >  pi_effective_date THEN
    RETURN(TRUE);
 ELSE
   RETURN(FALSE);
 END IF;

END element_has_future_dated_membs;
--
----------------------------------------------------------------------------------
--
FUNCTION get_flex_cols RETURN Nm3type.tab_varchar80 IS

  CURSOR c1  IS
  SELECT column_name
  FROM   all_tab_columns
        ,HIG_CODES
  WHERE  owner      =   Sys_Context('NM3CORE','APPLICATION_OWNER')
  AND    table_name =   'NM_ELEMENTS'
  AND    hco_domain =   'NM_ELEMENTS_COLUMNS'
  AND    hco_code = column_name
  ORDER BY hco_seq;

  l_retval Nm3type.tab_varchar80;

BEGIN


 OPEN c1;
 FETCH c1 BULK COLLECT INTO l_retval;
 CLOSE c1;

 RETURN(l_retval);

END;
--
----------------------------------------------------------------------------------
--
FUNCTION get_non_flex_cols RETURN Nm3type.tab_varchar80 IS

  CURSOR c1  IS
  SELECT column_name
  FROM   all_tab_columns
  WHERE  owner      = Sys_Context('NM3CORE','APPLICATION_OWNER')
  AND    table_name = 'NM_ELEMENTS'
  AND NOT EXISTS (SELECT 'x'
                  FROM   HIG_CODES
				  WHERE  hco_domain = 'NM_ELEMENTS_COLUMNS'
				  AND    hco_code   = column_name);

  l_retval Nm3type.tab_varchar80;

BEGIN


 OPEN c1;
 FETCH c1 BULK COLLECT INTO l_retval;
 CLOSE c1;

 RETURN(l_retval);

END;
--
----------------------------------------------------------------------------------
--
FUNCTION is_a_flex_col(pi_column_name IN all_tab_columns.column_name%TYPE) RETURN VARCHAR2 IS

  l_tab_flx_cols Nm3type.tab_varchar80;

BEGIN

 l_tab_flx_cols := get_flex_cols;

 FOR i IN 1..l_tab_flx_cols.COUNT LOOP

   IF l_tab_flx_cols(i) = UPPER(pi_column_name) THEN
     RETURN('Y');
   END IF;

 END LOOP;

-- if we get to here i.e. no match found then return 'N' by default
 RETURN('N');

END;
--
----------------------------------------------------------------------------------
--
FUNCTION is_not_a_flex_col(pi_column_name IN all_tab_columns.column_name%TYPE) RETURN VARCHAR2 IS

  l_tab_non_flx_cols Nm3type.tab_varchar80;

BEGIN

 l_tab_non_flx_cols := get_non_flex_cols;

 FOR i IN 1..l_tab_non_flx_cols.COUNT LOOP

   IF l_tab_non_flx_cols(i) = UPPER(pi_column_name) THEN
     RETURN('Y');
   END IF;

 END LOOP;

-- if we get to here i.e. no match found then return 'N' by default
 RETURN('N');

END;
--
----------------------------------------------------------------------------------
--
FUNCTION are_elements_identical (p_old_rec nm_elements%ROWTYPE
                                ,p_new_rec nm_elements%ROWTYPE
                                ) RETURN BOOLEAN IS

   c_nvl CONSTANT VARCHAR2(30) := Nm3type.c_nvl;

BEGIN

   RETURN (   p_old_rec.ne_unique                    = p_new_rec.ne_unique
          AND p_old_rec.ne_type                      = p_new_rec.ne_type
          AND p_old_rec.ne_nt_type                   = p_new_rec.ne_nt_type
          AND p_old_rec.ne_descr                     = p_new_rec.ne_descr
          AND NVL(p_old_rec.ne_length,-1)            = NVL(p_new_rec.ne_length,-1)
          AND p_old_rec.ne_admin_unit                = p_new_rec.ne_admin_unit
          AND NVL(p_old_rec.ne_gty_group_type,c_nvl) = NVL(p_new_rec.ne_gty_group_type,c_nvl)
          AND NVL(p_old_rec.ne_owner,c_nvl)          = NVL(p_new_rec.ne_owner,c_nvl)
          AND NVL(p_old_rec.ne_name_1,c_nvl)         = NVL(p_new_rec.ne_name_1,c_nvl)
          AND NVL(p_old_rec.ne_name_2,c_nvl)         = NVL(p_new_rec.ne_name_2,c_nvl)
          AND NVL(p_old_rec.ne_prefix,c_nvl)         = NVL(p_new_rec.ne_prefix,c_nvl)
          AND NVL(p_old_rec.ne_number,c_nvl)         = NVL(p_new_rec.ne_number,c_nvl)
          AND NVL(p_old_rec.ne_sub_type,c_nvl)       = NVL(p_new_rec.ne_sub_type,c_nvl)
          AND NVL(p_old_rec.ne_group,c_nvl)          = NVL(p_new_rec.ne_group,c_nvl)
          AND NVL(p_old_rec.ne_no_start,-1)          = NVL(p_new_rec.ne_no_start,-1)
          AND NVL(p_old_rec.ne_no_end,-1)            = NVL(p_new_rec.ne_no_end,-1)
          AND NVL(p_old_rec.ne_sub_class,c_nvl)      = NVL(p_new_rec.ne_sub_class,c_nvl)
          AND NVL(p_old_rec.ne_nsg_ref,c_nvl)        = NVL(p_new_rec.ne_nsg_ref,c_nvl)
          AND NVL(p_old_rec.ne_version_no,c_nvl)     = NVL(p_new_rec.ne_version_no,c_nvl)
          );

END are_elements_identical;
--
----------------------------------------------------------------------------------
--
PROCEDURE process_table_nt
IS
   CURSOR c1 (pi_nlt_nt_type NM_LINEAR_TYPES.nlt_nt_type%TYPE)
   IS
      SELECT *
        FROM NM_LINEAR_TYPES
       WHERE nlt_nt_type = pi_nlt_nt_type;
   l_rec_nlt   NM_LINEAR_TYPES%ROWTYPE;
BEGIN
  --
   IF g_tab_nt.COUNT > 0
   THEN

     FOR i IN g_tab_nt.FIRST..g_tab_nt.LAST
     LOOP
     --
       OPEN c1 (g_tab_nt(i).nt_type);
       FETCH c1
        INTO l_rec_nlt;
       IF c1%FOUND
       THEN
          Nm3del.del_nlt (pi_nlt_id => l_rec_nlt.nlt_id);
       END IF;
       CLOSE c1;
     --
     END LOOP;
  --
  END IF;
--
END process_table_nt;
--
-----------------------------------------------------------------------------
--
FUNCTION module_can_process_nt(pi_ntsm_hmo_module IN nm_type_specific_modules.ntsm_hmo_module%TYPE
                              ,pi_ntsm_nt_type    IN nm_type_specific_modules.ntsm_nt_type%TYPE) RETURN BOOLEAN IS


 l_retval                    BOOLEAN := TRUE; 
 l_count_ntsm_for_nt         PLS_INTEGER;
 l_count_ntsm_for_nt_and_mod PLS_INTEGER;  

BEGIN

 SELECT COUNT(*)
 INTO   l_count_ntsm_for_nt
 FROM   nm_type_specific_modules
 WHERE  ntsm_nt_type = pi_ntsm_nt_type;
 
--
-- If there are NO type specific modules for the network type the return TRUE
-- otherwise if there is a restriction then check that the restriction is against
-- our specific module
-- 
 IF l_count_ntsm_for_nt >0 THEN
   SELECT COUNT(*)
   into   l_count_ntsm_for_nt_and_mod
   FROM   nm_type_specific_modules
   WHERE  ntsm_nt_type = pi_ntsm_nt_type
   AND    ntsm_hmo_module = pi_ntsm_hmo_module;

   IF l_count_ntsm_for_nt_and_mod = 0 THEN
     l_retval := FALSE;
   END IF;

 END IF;

 RETURN(l_retval); 
   

END module_can_process_nt;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_id_and_type_from_unique(pi_unique    IN VARCHAR2
                                     ,po_id        OUT NUMBER
                                     ,po_type      OUT VARCHAR2) IS

-- procedure to support the gaz query network selection widget (initially
-- only on forms module NM0575 - but could be plugged into the other forms
-- to enable a network extent to be entered in the 'UNIQUE' field without
-- having to go thru the gazetteer from
--
-- given a unique that could be either that of an element or a saved extent
-- this procedure will check both data sets and return a match



 l_ne_rec   nm_elements_all%ROWTYPE;
 l_nse_rec  nm_saved_extents%ROWTYPE;
                                        
BEGIN

  IF pi_unique IS NOT NULL THEN
         
          BEGIN
	   		  l_ne_rec:= nm3get.get_ne(pi_ne_id           => nm3net.get_ne_id(p_ne_unique => pi_unique)
  			                          ,pi_raise_not_found => FALSE);
          EXCEPTION
          	 WHEN others THEN
          	   Null;  -- cos we want to carry on and see if this is an extent
          END;
         
          IF l_ne_rec.ne_id IS NOT NULL THEN -- if we found a record then   			                             
             po_id   := l_ne_rec.ne_id;
             po_type := l_ne_rec.ne_type;
		  ELSE
		     l_nse_rec := nm3get.get_nse(pi_nse_name => pi_unique);          				                             

             po_id   := l_nse_rec.nse_id;
             po_type := nm3extent.get_c_roi_extent;

		  END IF;                       
  			  
   END IF; 

EXCEPTION
  WHEN others THEN
   hig.raise_ner(pi_appl => 'HIG'
                ,pi_id   => 29);			

END  get_id_and_type_from_unique;
--
-----------------------------------------------------------------------------
--
-- MJA add 31-Aug-07
-- Speaks for itself.  If true then bypass triggers.
-- To be called in NM_MEMBERS_SDO_TRG, NM_MEMBERS_B_IU_END_SLK_TRG,
--   NM_MEMBERS_ALL_EXCL_B_STM, NM_MEMBERS_ALL_EXCL_B_ROW, NM_MEMBERS_ALL_EXCL_A_STM
--   NM_MEMBERS_ALL_AU_INSERT_CHECK triggers to see if bypass required
--
FUNCTION bypass_nm_members_trgs 
  RETURN BOOLEAN
IS
  --
Begin
  --
  Return nvl(g_bypass_nm_members_trgs, FALSE);
  --
End bypass_nm_members_trgs;
--
----------------------------------------------------------------------------------
--
-- MJA add 31-Aug-07
-- Speaks for itself.  If true then bypass triggers.
-- To be called in NM_ELEMENTS_ALL_AU_CHECK, NM_ELEMENTS_ALL_DT_TRG, NM_ELEMENTS_ALL_WHO,
--   NM_ELEMENTS_ALL_BS_NSG_VAL, NM_ELEMENTS_ALL_BR_NSG_VAL, NM_ELEMENTS_ALL_AS_NSG_VAL
--   triggers to see if bypass required
--
FUNCTION bypass_nm_elements_trgs 
  RETURN BOOLEAN
IS
  --
Begin
  --
  Return nvl(g_bypass_nm_elements_trgs, FALSE);
  --
End bypass_nm_elements_trgs;
--
----------------------------------------------------------------------------------
--
-- MJA add 31-Aug-07
-- Speaks for itself.  If true then bypass triggers.
-- To be called in NM_POINTS_SDO, NM_POINTS_SDO_ROW triggers to see if bypass required
--
FUNCTION bypass_nm_points_trgs 
  RETURN BOOLEAN
IS
  --
Begin
  --
  Return nvl(g_bypass_nm_points_trgs, FALSE);
  --
End bypass_nm_points_trgs;
--
----------------------------------------------------------------------------------
--
-- MJA add 31-Aug-07
-- Sets global g_bypass_nm_members_trgs true or false.
--
PROCEDURE bypass_nm_members_trgs ( pi_mode IN BOOLEAN )
IS
  --
Begin
  --
  g_bypass_nm_members_trgs := pi_mode;
  --
End bypass_nm_members_trgs;
--
----------------------------------------------------------------------------------
--
-- MJA add 31-Aug-07
-- Sets global g_bypass_nm_elements_trgs true or false.
--
PROCEDURE bypass_nm_elements_trgs ( pi_mode IN BOOLEAN )
IS
  --
Begin
  --
  g_bypass_nm_elements_trgs := pi_mode;
  --
End bypass_nm_elements_trgs;
--
----------------------------------------------------------------------------------
--
-- MJA add 31-Aug-07
-- Sets global g_bypass_nm_points_trgs true or false.
--
PROCEDURE bypass_nm_points_trgs ( pi_mode IN BOOLEAN )
IS
  --
Begin
  --
  g_bypass_nm_points_trgs := pi_mode;
  --
End bypass_nm_points_trgs;
--
----------------------------------------------------------------------------------
--
END Nm3net;
/
