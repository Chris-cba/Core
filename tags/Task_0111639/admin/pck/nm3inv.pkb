CREATE OR REPLACE PACKAGE BODY Nm3inv AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3inv.pkb-arc   2.27.1.0   Nov 10 2011 09:23:36   Ade.Edwards  $
--       Module Name      : $Workfile:   nm3inv.pkb  $
--       Date into SCCS   : $Date:   Nov 10 2011 09:23:36  $
--       Date fetched Out : $Modtime:   Nov 10 2011 09:21:00  $
--       SCCS Version     : $Revision:   2.27.1.0  $
--       Based on --
--
--   nm3inv package body
--
-- Amendments:-
-- 30/11/2005  CParkinson  Add function get_inv_domain_value
-- 24/01/2006  PStanton Added overloaded version of get_all_attrib_values to be used when
--             when dealing with foreign table assets
-- 13/06/2008  PT Log 710984: modified get_attribute_value() to not raise >1 assets error
--              when two assets are touching on the point of interest.
--              the value that starts at the point is returned
-- 23/06/2008  PT the above change now depends on sysopt 'ATTRVALUEV' value Y | N default N
--              only use the new logic if sysopt value is 'Y'

-----------------------------------------------------------------------------
--      Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
--
--all global package variables here
--
--  g_body_sccsid is the SCCS ID for the package body
   g_body_sccsid        CONSTANT varchar2(2000) := '$Revision:   2.27.1.0  $';
   g_package_name   CONSTANT VARCHAR2(30) := 'nm3inv';
--
   --<USED BY validate_rec_iit>
   g_last_inv_type_dyn_val NM_INV_TYPES.nit_inv_type%TYPE;
   g_inv_val_tab_varchar   Nm3type.tab_varchar32767;
   --</USED BY validate_rec_iit>
--
   --<USED BY GET_ATTRIBUTE_VALUE_x Funcs>
   g_datatype              VARCHAR2(10);
   g_last_date_mask        VARCHAR2(100);
   --</USED BY GET_ATTRIBUTE_VALUE_x Funcs>
   --
   g_xav_procedure_exists    BOOLEAN;
   g_checked_for_xav_proc    BOOLEAN := FALSE;
   --
   --<USED TO keep a list of all cols in NM_INV_ITEMS which are valid for begin flexible>
   g_tab_flex_col Nm3type.tab_varchar30;
   --</USED TO keep a list of all cols in NM_INV_ITEMS which are valid for begin flexible>
   --;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_ita_by_attrib_name (pi_inv_type      IN NM_INV_TYPE_ATTRIBS.ita_inv_type%TYPE
                              ,pi_attrib_name IN NM_INV_TYPE_ATTRIBS.ita_attrib_name%TYPE
                             ) RETURN NM_INV_TYPE_ATTRIBS%ROWTYPE;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_version RETURN VARCHAR2 IS
BEGIN
  RETURN g_sccsid;
END get_version;
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_units( p_unit_id IN NUMBER ) RETURN VARCHAR2 IS
--
BEGIN
--
  RETURN Nm3unit.get_unit_name (p_unit_id);
--
END get_units;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_nt_unique( p_type IN VARCHAR2 ) RETURN VARCHAR2 IS
--
BEGIN
--
  RETURN Nm3net.get_nt_unique (p_type);
--
END get_nt_unique;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_nit_descr(p_inv_type IN NM_INV_TYPES.nit_inv_type%TYPE
                        ,p_parent_type IN NM_INV_TYPES.nit_inv_type%TYPE DEFAULT NULL)
         RETURN NM_INV_TYPES.nit_descr%TYPE IS
--
  CURSOR c2 IS
    SELECT nit_descr
    FROM   NM_INV_TYPES
          ,NM_INV_TYPE_GROUPINGS
    WHERE  nit_inv_type = itg_inv_type
    AND    itg_parent_inv_type = p_parent_type
    AND    nit_inv_type = p_inv_type
    AND    itg_inv_type != itg_parent_inv_type;

--
   l_retval NM_INV_TYPES.nit_descr%TYPE;
--
BEGIN
--
  IF p_parent_type IS NULL
   THEN
    l_retval  := get_inv_type( p_inv_type).nit_descr;
  ELSE
    OPEN c2;
    FETCH c2 INTO l_retval;
    IF c2%NOTFOUND THEN
      CLOSE c2;
      RAISE_APPLICATION_ERROR( -20001
         ,Hig.replace_strings_in_message(g_thing_does_not_exist, 'Inventory Type'));
    END IF;
    CLOSE c2;
  END IF;
--
  RETURN l_retval;
--
END get_nit_descr;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_nit_pnt_or_cont( p_type IN VARCHAR2 ) RETURN VARCHAR2 IS
--
BEGIN
--
  RETURN get_inv_type( p_type).nit_pnt_or_cont;
--
END get_nit_pnt_or_cont;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_top_item_type ( p_type IN VARCHAR2) RETURN VARCHAR2 IS
CURSOR c1 IS
  SELECT b.itg_parent_inv_type
  FROM NM_INV_TYPE_GROUPINGS b
    WHERE NOT EXISTS (
       SELECT 'x' FROM NM_INV_TYPE_GROUPINGS c
       WHERE c.itg_inv_type = b.itg_parent_inv_type )
  CONNECT BY PRIOR itg_parent_inv_type = itg_inv_type
  START WITH itg_inv_type = p_type;

  l_retval NM_INV_TYPES.nit_inv_type%TYPE;
BEGIN
  OPEN c1;
  FETCH c1 INTO l_retval;
  IF c1%NOTFOUND THEN
    l_retval := p_type;
  END IF;
  CLOSE c1;
  RETURN l_retval;
END get_top_item_type;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_inv_type_icon(p_inv_type IN VARCHAR2) RETURN VARCHAR2 IS
--
   l_rec_nit NM_INV_TYPES%ROWTYPE;
--
BEGIN
--
   l_rec_nit := get_inv_type( p_inv_type);
   RETURN REPLACE(UPPER(l_rec_nit.nit_icon_name), '.ICO', '');
--
END get_inv_type_icon;
--
----------------------------------------------------------------------------------------------
--
----------------------------------------------------------------------------
-- Start of functions and procedures required for inventory view creattion
-- via mai1400
--
FUNCTION view_exists ( inv_view_name IN NM_INV_TYPES.nit_view_name%TYPE ) RETURN BOOLEAN IS
--
BEGIN
--
   RETURN Nm3ddl.does_object_exist (inv_view_name, 'VIEW');
--
END view_exists;
--
----------------------------------------------------------------------------------------------
--
--
-- Check if the existing view is in use within the database.
--
FUNCTION view_in_use ( p_view_name IN NM_INV_TYPES.nit_view_name%TYPE ) RETURN BOOLEAN IS
--
   exclusive_mode INTEGER := 6;
   ID             INTEGER := 100;
--
   CURSOR in_use IS -- Dummy cursor for the present.
   SELECT 1
    FROM  dual;
--
   v_in_use INTEGER;
--
   l_retval BOOLEAN;
--
BEGIN
--
   OPEN  in_use;
--
   FETCH in_use INTO v_in_use;
--
-- Reversed logic so that function
-- does not fail.
   l_retval := in_use%NOTFOUND;
--
   CLOSE in_use;
--
   RETURN l_retval;
--
END view_in_use;
--
----------------------------------------------------------------------------------------------
--
--
FUNCTION synonym_exists(SYNONYM IN NM_INV_TYPES.nit_view_name%TYPE) RETURN BOOLEAN IS
--
BEGIN
--
   RETURN Nm3ddl.check_syn_exists('PUBLIC',SYNONYM);
--
END synonym_exists;
--
----------------------------------------------------------------------------------------------
--
--
-- When called, this procedure should perform the actual creation of the
-- specified inventory view. A return code should be provided if there were any
-- problems when creating the view object. ( Such as insufficient privelages ).
--
--
PROCEDURE create_view (p_inventory_type  IN NM_INV_TYPES.nit_inv_type%TYPE
                      ,p_join_to_network IN BOOLEAN DEFAULT FALSE
                      ) IS
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'create_view');
--
-- Code moved into NM3INV_VIEW package
--
   Nm3inv_View.create_view(p_inventory_type, p_join_to_network);
--
   Nm_Debug.proc_end(g_package_name,'create_view');
--
END create_view;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE create_inv_view (p_inventory_type  IN  NM_INV_TYPES.nit_inv_type%TYPE
                          ,p_join_to_network IN  BOOLEAN DEFAULT FALSE
                          ,p_view_name       OUT user_views.view_name%TYPE
                          ) IS
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'create_inv_view');
--
-- Code moved into NM3INV_VIEW package
--
   Nm3inv_View.create_inv_view (p_inventory_type
                               ,p_join_to_network
                               ,p_view_name
                               );
--
   Nm_Debug.proc_end(g_package_name,'create_inv_view');
--
END create_inv_view;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_create_inv_view_text (p_inventory_type   IN NM_INV_TYPES.nit_inv_type%TYPE
                                  ,p_join_to_network  IN BOOLEAN DEFAULT FALSE
                                  ) RETURN VARCHAR2 IS
--
BEGIN
--
-- Code moved into NM3INV_VIEW package
--
   RETURN Nm3inv_View.get_create_inv_view_text(p_inventory_type,p_join_to_network);
--
END get_create_inv_view_text;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE create_all_inv_views IS
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'create_all_inv_views');
--
-- Code moved into NM3INV_VIEW package
--
   Nm3inv_View.create_all_inv_views;
--
   Nm_Debug.proc_end(g_package_name,'create_all_inv_views');
--
END create_all_inv_views;
--
----------------------------------------------------------------------------------------------
--
FUNCTION work_out_inv_type_view_name (pi_inv_type         IN NM_INV_TYPES.nit_inv_type%TYPE
                                     ,pi_join_to_network  IN BOOLEAN DEFAULT FALSE
                                     ) RETURN VARCHAR2 IS
--
BEGIN
--
-- Code moved into NM3INV_VIEW package
--
   RETURN Nm3inv_View.work_out_inv_type_view_name(pi_inv_type,pi_join_to_network);
--
END work_out_inv_type_view_name;
--
----------------------------------------------------------------------------------------------
--
FUNCTION derive_inv_type_view_name (pi_inv_type IN NM_INV_TYPES.nit_inv_type%TYPE)
 RETURN VARCHAR2 IS
BEGIN
--
-- Code moved into NM3INV_VIEW package
--
   RETURN Nm3inv_View.derive_inv_type_view_name(pi_inv_type);
--
END derive_inv_type_view_name;
--
----------------------------------------------------------------------------------------------
--
FUNCTION derive_nw_inv_type_view_name (pi_inv_type IN NM_INV_TYPES.nit_inv_type%TYPE)
 RETURN VARCHAR2 IS
BEGIN
--
-- Code moved into NM3INV_VIEW package
--
   RETURN Nm3inv_View.derive_nw_inv_type_view_name(pi_inv_type);
--
END derive_nw_inv_type_view_name;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_iit_pk ( p_item_id IN NUMBER ) RETURN VARCHAR2 IS
--
   l_iit_pk NM_INV_ITEMS.iit_primary_key%TYPE;
--
BEGIN
--
  l_iit_pk := get_inv_primary_key (p_item_id);
--
  IF l_iit_pk IS NULL THEN
    l_iit_pk :=  'Asset '||TO_CHAR(p_item_id );
  END IF;
--
  RETURN l_iit_pk;
--
END get_iit_pk;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_xsp_descr(p_inv_type IN XSP_RESTRAINTS.xsr_ity_inv_code%TYPE
                      ,p_x_sect_val IN XSP_RESTRAINTS.xsr_x_sect_value%TYPE
                      ,p_nw_type IN XSP_RESTRAINTS.xsr_nw_type%TYPE
                      ,p_scl_class IN XSP_RESTRAINTS.xsr_scl_class%TYPE)
         RETURN XSP_RESTRAINTS.xsr_descr%TYPE IS

  CURSOR c1 IS
    SELECT xsr_descr
    FROM   XSP_RESTRAINTS
    WHERE  xsr_x_sect_value = p_x_sect_val
    AND    xsr_ity_inv_code = p_inv_type
    AND    NVL(xsr_scl_class,Nm3type.c_nvl) = NVL(p_scl_class, NVL(xsr_scl_class,Nm3type.c_nvl))
    AND    xsr_nw_type= NVL(p_nw_type, xsr_nw_type);

  l_retval XSP_RESTRAINTS.xsr_descr%TYPE;

BEGIN

  OPEN c1;
  FETCH c1 INTO l_retval;
  IF c1%NOTFOUND THEN
    CLOSE c1;
    RAISE_APPLICATION_ERROR( -20001
         ,Hig.replace_strings_in_message(g_thing_does_not_exist, 'XSP'));
  END IF;
  CLOSE c1;

  RETURN l_retval;

END;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE pop_inv_colours IS

resource_busy EXCEPTION;
PRAGMA EXCEPTION_INIT( resource_busy, -54 );

BEGIN

  LOCK TABLE NM_INV_TYPE_COLOURS IN EXCLUSIVE MODE NOWAIT;

  DELETE FROM NM_INV_TYPE_COLOURS;

  INSERT INTO NM_INV_TYPE_COLOURS
  ( col_id, ity_inv_code )
  SELECT ROWNUM, nit_inv_type
  FROM NM_INV_TYPES;

EXCEPTION
  WHEN resource_busy THEN
    RAISE_APPLICATION_ERROR( -20001, 'Colour Map is being used, try again later ');
END;
--
----------------------------------------------------------------------------------------------
--
-- GJ 22-AUG-2005
-- There appears to be a similar function nm3asset but - heh...I didn't write this so
-- although it's bobbins I ain't gonna consolidate them - cos it'll probably cause mayhem
FUNCTION get_ita_domain_sql(pi_ita_id_domain IN NM_INV_TYPE_ATTRIBS_ALL.ita_id_domain%TYPE) RETURN VARCHAR2 IS
BEGIN
 RETURN('SELECT ial_value id, ial_meaning, ial_value FROM nm_inv_attri_lookup WHERE ial_domain = '||Nm3flx.string(pi_ita_id_domain));
END get_ita_domain_sql;
--
----------------------------------------------------------------------------------------------
--

FUNCTION build_ita_lov_sql_string (pi_ita_inv_type               IN NM_INV_TYPE_ATTRIBS_ALL.ita_inv_type%TYPE
                                  ,pi_ita_attrib_name            IN NM_INV_TYPE_ATTRIBS_ALL.ita_attrib_name%TYPE
                                  ,pi_include_bind_variable      IN BOOLEAN DEFAULT FALSE
							      ,pi_replace_bind_variable_with IN VARCHAR2 DEFAULT NULL
                                  ) RETURN VARCHAR2 IS
--
   l_retval  VARCHAR2(32767) := NULL;
--
   l_rec_ita NM_INV_TYPE_ATTRIBS_ALL%ROWTYPE;
--
BEGIN
--
   l_rec_ita := Nm3get.get_ita (pi_ita_inv_type    => pi_ita_inv_type
                               ,pi_ita_attrib_name => pi_ita_attrib_name
							   ,pi_raise_not_found => FALSE
                               );

   IF l_rec_ita.ita_query IS NOT NULL
       THEN

         IF pi_include_bind_variable THEN  -- just return the basic query bind variables and all
		   l_retval := l_rec_ita.ita_query;

	     ELSIF pi_replace_bind_variable_with IS NOT NULL THEN  -- replace bind variable with given value

            IF INSTR(pi_replace_bind_variable_with,'%') != 0 THEN
               Hig.raise_ner(pi_appl => 'NET'
                            ,pi_id   => 394
                            ,pi_supplementary_info => CHR(10)||Nm3flx.string(l_rec_ita.ita_scrn_text));
            END IF;

		   l_retval := REPLACE(l_rec_ita.ita_query
		                      ,Nm3flx.extract_bind_variable(l_rec_ita.ita_query)
							  ,Nm3flx.string(pi_replace_bind_variable_with)
							  );
		 ELSE
           -- This is a query so sort that out by removing any refs to bind variables
           l_retval := Nm3flx.remove_bind_variable_refs (l_rec_ita.ita_query);
		 END IF;
      ELSIF l_rec_ita.ita_id_domain IS NOT NULL
       THEN
         -- This is an inventory domain
         l_retval := get_ita_domain_sql(pi_ita_id_domain => l_rec_ita.ita_id_domain);
      END IF;
--
--
-- check that whatever sql has been derived that it is valid
--
   IF l_retval IS NOT NULL AND NOT Nm3flx.is_select_statement_valid (p_sql => l_retval) THEN
    Hig.raise_ner(pi_appl => 'NET'
                 ,pi_id   => 388
				 ,pi_supplementary_info => CHR(10)||Nm3flx.string(l_rec_ita.ita_scrn_text)||CHR(10)||l_retval); -- Parse error in query
   END IF;

   RETURN l_retval;
--
--
END build_ita_lov_sql_string;
--
----------------------------------------------------------------------------------------------
--
-- Procedure to validate and return foreign key value
  PROCEDURE valid_fk_ial
        ( a_ial_domain  IN      NM_INV_ATTRI_LOOKUP.ial_domain%TYPE
        , a_ial_value   IN      NM_INV_ATTRI_LOOKUP.ial_value%TYPE
        , a_ial_meaning IN OUT  NM_INV_ATTRI_LOOKUP.ial_meaning%TYPE
  ) AS
--
  CURSOR c_ial IS
  SELECT ial_meaning
   FROM  NM_INV_ATTRI_LOOKUP
   WHERE ial_domain = a_ial_domain
    AND  ial_value  = a_ial_value;
--    AND   SYSDATE BETWEEN NVL(ial_start_date,SYSDATE)
--                  AND     NVL(ial_end_date,SYSDATE);
--
  b_notfound BOOLEAN DEFAULT FALSE;
--
  BEGIN
--
    OPEN  c_ial;
    FETCH c_ial INTO a_ial_meaning;
    b_notfound := c_ial%NOTFOUND;
    CLOSE c_ial;
--
    IF (b_notfound) THEN
       RAISE_APPLICATION_ERROR( -20001
         ,Hig.replace_strings_in_message(g_thing_does_not_exist,a_ial_domain));
    END IF;
--
  END valid_fk_ial;
--
----------------------------------------------------------------------------------------------
-- Procedure to validate and return foreign key value (Overloaded in
-- the use of the date at which th evalidation is to apply. )
-- The date is passed as a varchar2 of a specified mask since Pl/SQL 1
-- differs in the way date parameters are held to PL/SQL 2.
--
  PROCEDURE valid_fk_ial
        ( a_ial_domain  IN      NM_INV_ATTRI_LOOKUP.ial_domain%TYPE
        , a_ial_value   IN      NM_INV_ATTRI_LOOKUP.ial_value%TYPE
        , a_ial_meaning IN OUT  NM_INV_ATTRI_LOOKUP.ial_meaning%TYPE
        , a_effective   IN      VARCHAR2
        , a_date_mask   IN      VARCHAR2 := 'DD-MON-YYYY'
  ) AS
--
  CURSOR c_ial IS
    SELECT ial_meaning
    FROM NM_INV_ATTRI_LOOKUP nial,NM_INV_DOMAINS nid
    WHERE nid.id_domain = nial.ial_domain
    AND   nial.ial_domain  = a_ial_domain
    AND   nial.ial_value =    a_ial_value;
--    AND    TO_DATE( NVL(a_effective,TO_CHAR(SYSDATE, a_date_mask)), a_date_mask ) BETWEEN
--             NVL(ial_start_date,  TO_DATE( NVL(a_effective, TO_CHAR(SYSDATE, a_date_mask)), a_date_mask))
--      AND    NVL(ial_end_date,    TO_DATE( NVL(a_effective, TO_CHAR(SYSDATE, a_date_mask)), a_date_mask));
--
  b_notfound BOOLEAN DEFAULT FALSE;
  BEGIN
    OPEN c_ial;
    FETCH c_ial INTO a_ial_meaning;
    b_notfound := c_ial%NOTFOUND;
    CLOSE c_ial;
    IF (b_notfound) THEN
       RAISE_APPLICATION_ERROR( -20001
         ,Hig.replace_strings_in_message(g_thing_does_not_exist,a_ial_domain));
    END IF;
  END valid_fk_ial;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE valid_fk_ial
       (a_ial_domain   IN     NM_INV_ATTRI_LOOKUP.ial_domain%TYPE
       ,a_ial_value    IN     NUMBER
       ,a_ial_meaning  IN OUT NM_INV_ATTRI_LOOKUP.ial_meaning%TYPE
       ) IS
BEGIN
--
   valid_fk_ial
        (a_ial_domain  => a_ial_domain
        ,a_ial_value   => LTRIM(TO_CHAR(a_ial_value))
        ,a_ial_meaning => a_ial_meaning
        );
--
END valid_fk_ial;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE valid_fk_ial
       (a_ial_domain   IN     NM_INV_ATTRI_LOOKUP.ial_domain%TYPE
       ,a_ial_value    IN     DATE
       ,a_ial_meaning  IN OUT NM_INV_ATTRI_LOOKUP.ial_meaning%TYPE
       ) IS
  CURSOR c_ial IS
  SELECT ial_meaning
   FROM  NM_INV_ATTRI_LOOKUP
   WHERE ial_domain                                         = a_ial_domain
    AND  TO_CHAR(Hig.date_convert(ial_value),Nm3type.c_full_date_time_format) = TO_CHAR(a_ial_value,Nm3type.c_full_date_time_format);
  b_notfound BOOLEAN DEFAULT FALSE;
BEGIN
    OPEN c_ial;
    FETCH c_ial INTO a_ial_meaning;
    b_notfound := c_ial%NOTFOUND;
    CLOSE c_ial;
    IF (b_notfound) THEN
       RAISE_APPLICATION_ERROR( -20001
         ,Hig.replace_strings_in_message(g_thing_does_not_exist,a_ial_domain));
    END IF;
--
END valid_fk_ial;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_inv_domain_meaning(pi_domain IN NM_INV_ATTRI_LOOKUP_ALL.ial_domain%TYPE
                               ,pi_value  IN NM_INV_ATTRI_LOOKUP_ALL.ial_value%TYPE
                               ) RETURN NM_INV_ATTRI_LOOKUP_ALL.ial_meaning%TYPE IS

  CURSOR c1(p_domain IN NM_INV_ATTRI_LOOKUP_ALL.ial_domain%TYPE
           ,p_value  IN NM_INV_ATTRI_LOOKUP_ALL.ial_value%TYPE) IS
    SELECT
      ial.ial_meaning
    FROM
      NM_INV_ATTRI_LOOKUP_ALL ial
    WHERE
      ial.ial_domain = p_domain
    --CWS 0109619 Any end dated domains fail regardless of when the end date is.
    AND 
      ial.ial_end_date IS NULL
    --
    AND
      ial.ial_value = p_value;

  l_retval NM_INV_ATTRI_LOOKUP_ALL.ial_meaning%TYPE;

BEGIN
  OPEN c1(p_domain => pi_domain
         ,p_value  => pi_value);
    FETCH c1 INTO l_retval;
    IF c1%NOTFOUND
    THEN
      CLOSE c1;
      RAISE_APPLICATION_ERROR(-20001, 'Inventory domain ' || pi_domain
                                      || ', value ' || pi_value
                                      || ' not found.');
    END IF;
  CLOSE c1;

  RETURN l_retval;
END get_inv_domain_meaning;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_inv_domain_meaning(pi_domain IN NM_INV_ATTRI_LOOKUP_ALL.ial_domain%TYPE
                               ,pi_value  IN NUMBER
                               ) RETURN NM_INV_ATTRI_LOOKUP_ALL.ial_meaning%TYPE IS
BEGIN
   RETURN get_inv_domain_meaning(pi_domain => pi_domain
                                ,pi_value  => LTRIM(TO_CHAR(pi_value))
                                );
END get_inv_domain_meaning;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_inv_domain_meaning(pi_domain IN NM_INV_ATTRI_LOOKUP_ALL.ial_domain%TYPE
                               ,pi_value  IN DATE
                               ) RETURN NM_INV_ATTRI_LOOKUP_ALL.ial_meaning%TYPE IS

  CURSOR c1(p_domain IN NM_INV_ATTRI_LOOKUP_ALL.ial_domain%TYPE
           ,p_value  IN NM_INV_ATTRI_LOOKUP_ALL.ial_value%TYPE) IS
    SELECT
      ial.ial_meaning
    FROM
      NM_INV_ATTRI_LOOKUP_ALL ial
    WHERE
      ial.ial_domain = p_domain
    AND
      TO_CHAR(Hig.date_convert(ial.ial_value),Nm3type.c_full_date_time_format) = TO_CHAR(pi_value,Nm3type.c_full_date_time_format);

  l_retval NM_INV_ATTRI_LOOKUP_ALL.ial_meaning%TYPE;

BEGIN
  OPEN c1(p_domain => pi_domain
         ,p_value  => pi_value);
    FETCH c1 INTO l_retval;
    IF c1%NOTFOUND
    THEN
      CLOSE c1;
      RAISE_APPLICATION_ERROR(-20001, 'Inventory domain ' || pi_domain
                                      || ', value ' || pi_value
                                      || ' not found.');
    END IF;
  CLOSE c1;
  RETURN l_retval;
END get_inv_domain_meaning;
--
----------------------------------------------------------------------------------------------
--
-- CP 30/11/05
FUNCTION get_inv_domain_value (pi_domain  IN     NM_INV_ATTRI_LOOKUP_ALL.ial_domain%TYPE
                              ,pi_meaning IN OUT NM_INV_ATTRI_LOOKUP_ALL.ial_meaning%TYPE
                              ) RETURN NM_INV_ATTRI_LOOKUP_ALL.ial_value%TYPE IS

  CURSOR c1 (p_domain  IN NM_INV_ATTRI_LOOKUP_ALL.ial_domain%TYPE
            ,p_meaning IN NM_INV_ATTRI_LOOKUP_ALL.ial_meaning%TYPE) IS
    SELECT ial_value
          ,ial_meaning
    FROM   NM_INV_ATTRI_LOOKUP_ALL
    WHERE  ial_domain = p_domain
    AND    UPPER(ial_meaning) LIKE UPPER(p_meaning||'%');

  l_retval     NM_INV_ATTRI_LOOKUP_ALL.ial_value%TYPE;
  l_retmeaning NM_INV_ATTRI_LOOKUP_ALL.ial_meaning%TYPE;

BEGIN

  OPEN c1(p_domain   => pi_domain
         ,p_meaning  => pi_meaning);
  FETCH c1 INTO l_retval, l_retmeaning;
  IF c1%NOTFOUND THEN
    CLOSE c1;
    RAISE_APPLICATION_ERROR(-20001, 'Inventory domain ' || pi_domain
                                    || ', meaning ' || pi_meaning
                                    || ' not found.');
  END IF;
  CLOSE c1;
  pi_meaning := l_retmeaning;
  RETURN l_retval;

END get_inv_domain_value;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE validate_flex_inv (p_inv_type	              IN     VARCHAR2
                            ,p_attrib_name            IN     VARCHAR2
                            ,pi_value                 IN     DATE
                            ,po_value                    OUT VARCHAR2
                            ,po_meaning                  OUT VARCHAR2
                            ,pi_validate_domain_dates IN     BOOLEAN DEFAULT TRUE
                            ,pi_bind_variable_value   IN     VARCHAR2 DEFAULT NULL
                            ) IS
BEGIN
   validate_flex_inv (p_inv_type               => p_inv_type
                     ,p_attrib_name            => p_attrib_name
                     ,pi_value                 => TO_CHAR(pi_value,Nm3type.c_full_date_time_format)
                     ,po_value                 => po_value
                     ,po_meaning               => po_meaning
                     ,pi_validate_domain_dates => pi_validate_domain_dates
                     );
END validate_flex_inv;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE validate_flex_inv (p_inv_type               IN  VARCHAR2
                            ,p_attrib_name            IN  VARCHAR2
                            ,pi_value                 IN  VARCHAR2
                            ,po_value                 OUT VARCHAR2
                            ,po_meaning               OUT VARCHAR2
                            ,pi_validate_domain_dates IN  BOOLEAN  DEFAULT TRUE
                            ,pi_bind_variable_value   IN     VARCHAR2 DEFAULT NULL
                            ) IS
----
   l_rec_nita                  NM_INV_TYPE_ATTRIBS%ROWTYPE;
   l_qry Nm3type.max_varchar2;
   l_id     Nm3type.max_varchar2;
   l_num_length Varchar2(50) ; -- Log 702388:Linesh:11-Mar-09:Added
   l_raise_len_error  Boolean ;  -- Log 702388:Linesh:11-Mar-09:Added
   l_length Number ;-- Log 702388:Linesh:11-Mar-09:Added

--
BEGIN
--
   -- Initialise return arguments
   po_value   := NULL;
   po_meaning := NULL;
--
   --
   -- If the value passed in is null then just exit
   --
   IF pi_value IS NULL
    THEN
      RETURN;
   END IF;
--
   l_rec_nita := Nm3get.get_ita (pi_ita_inv_type    => p_inv_type
                               ,pi_ita_attrib_name => p_attrib_name
							   ,pi_raise_not_found => FALSE
                               );
--



	    l_qry := Nm3inv.build_ita_lov_sql_string (pi_ita_inv_type                  => p_inv_type
                                                 ,pi_ita_attrib_name               => p_attrib_name
                                                 ,pi_include_bind_variable         => TRUE
                                                 ,pi_replace_bind_variable_with    => NULL);

      --
      -- if we have a bind variable then re-build the query string to use the bind variable value passed in to our procedure
      --
      IF Nm3flx.extract_bind_variable(l_qry,1) IS NOT NULL THEN

	    l_qry := Nm3inv.build_ita_lov_sql_string (pi_ita_inv_type                  => p_inv_type
                                                 ,pi_ita_attrib_name               => p_attrib_name
                                                 ,pi_include_bind_variable         => FALSE
                                                 ,pi_replace_bind_variable_with    => pi_bind_variable_value);
      END IF;

--nm_debug.debug_on;
--nm_debug.debug('l_qry='||l_qry);
--nm_dbug

IF l_qry IS NOT NULL THEN

  BEGIN

      Nm3extlov.validate_lov_value	(p_statement => l_qry
                                    ,p_value     => pi_value
                                    ,p_meaning   => po_meaning
                                    ,p_id        => l_id
									,pi_match_col => 3) ;  -- important to match on the correct column in the sql query string

      po_value := l_id;

    EXCEPTION

     WHEN OTHERS THEN
       Hig.raise_ner(pi_appl => 'NET'
                    ,pi_id   => 389
                    ,pi_supplementary_info => CHR(10)||l_rec_nita.ita_scrn_text||CHR(10)||Nm3flx.string(pi_value));

     END;

   END IF;

--
   IF l_rec_nita.ita_format = Nm3type.c_date
    THEN
--
      DECLARE
         l_date  DATE;
         --
         -- Use the date format specified for the inv_type_attrib if there is one, otherwise
         --  use the user date mask
         --
         l_format_mask VARCHAR2(200) := NVL(l_rec_nita.ita_format_mask, Nm3user.get_user_date_mask);
      BEGIN
----
--         IF p_attrib_name LIKE '%DATE%'
--          THEN
--            l_date       := pi_value;
--         ELSE
            l_date       := Hig.date_convert(pi_value);
--         END IF;
--
         IF l_date IS NULL
          THEN
            Hig.raise_ner (pi_appl               => Nm3type.c_hig
                          ,pi_id                 => 148
                          ,pi_supplementary_info => pi_value
                          );
--            g_flex_validation_exc_code := -20704;
--            g_flex_validation_exc_msg  := 'Not a Valid Date String';
--            RAISE g_flex_validation_exception;
         END IF;
--
         po_value := TO_CHAR(l_date, l_format_mask);
--
      END;
--
   ELSIF l_rec_nita.ita_format = Nm3type.c_number
    THEN
--
      DECLARE
         l_number                 NUMBER;
         l_value                  VARCHAR2(2000) := LTRIM(RTRIM(NVL(l_id,pi_value)));
         c_format_string CONSTANT VARCHAR2(38)   := RPAD('9',38,'9');
      BEGIN
----
--         g_flex_validation_exc_code := -20702;
--         g_flex_validation_exc_msg  := 'Not a Valid Number';
--

         IF NOT Nm3flx.is_numeric(l_value)
          THEN
            Hig.raise_ner (pi_appl               => Nm3type.c_hig
                          ,pi_id                 => 111
                          ,pi_supplementary_info => pi_value
                          );
--            RAISE g_flex_validation_exception;
         END IF;
--
         l_number := TO_NUMBER(l_value);

         --Added this to validate the Number field
         -- Log 702388:Linesh:11-Mar-09:Start
         l_num_length := l_number ;
         IF Instr(l_num_length,'.') > 0
         THEN
             l_raise_len_error := Length(substr(to_number(l_num_length),1,Instr(l_num_length,'.')-1)) > l_rec_nita.ita_fld_length ;    
             l_length := Length(substr(to_number(l_num_length),1,Instr(l_num_length,'.')-1));                  
         ELSE
             l_raise_len_error := LENGTH(l_num_length) > l_rec_nita.ita_fld_length ;
             l_length          := LENGTH(l_num_length) ; 
         END IF ;
         IF l_raise_len_error
         THEN
             hig.raise_ner(pi_appl               => 'NET'
                          ,pi_id                 => 29
                          ,pi_supplementary_info => 'Length ' || l_length || ' is greater than column length ' || l_rec_nita.ita_fld_length 
                          );
         END IF ;
         IF  l_rec_nita.ita_dec_places IS NOT NULL
         AND Instr(l_num_length,'.') > 0   
         THEN
             IF Length(substr(l_num_length,Instr(l_num_length,'.')+1)) > l_rec_nita.ita_dec_places
             THEN
                 hig.raise_ner(pi_appl               => 'NET'
                   ,pi_id                 => 29
                   ,pi_supplementary_info => 'Decimal Places ' || Length(substr(l_num_length,Instr(l_num_length,'.')+1)) || ' is greater than column decimal places ' || l_rec_nita.ita_dec_places
                   );                 
             END IF ; 
         END IF ;          
         -- Log 702388:Linesh:11-Mar-09:End
--
         IF  NVL(l_rec_nita.ita_min,l_number) > l_number
          OR NVL(l_rec_nita.ita_max,l_number) < l_number
          THEN
            Hig.raise_ner (pi_appl               => Nm3type.c_net
                          ,pi_id                 => 29
                          ,pi_supplementary_info => pi_value||' NOT BETWEEN '||l_rec_nita.ita_min||' AND '||l_rec_nita.ita_max
                          );
--            RAISE g_flex_validation_exception;
         END IF;
--
         IF l_rec_nita.ita_units IS NOT NULL
          THEN
          --
            DECLARE
              ex_value_error EXCEPTION;
              PRAGMA EXCEPTION_INIT( ex_value_error, -6502 );
            BEGIN
              l_number   := TO_NUMBER(Nm3unit.get_formatted_value
                                          (p_value   => l_number
                                          ,p_unit_id => l_rec_nita.ita_units
                                          )
                                     );
              po_meaning := Nm3unit.get_unit_name (p_un_id => l_rec_nita.ita_units);
            EXCEPTION
              WHEN ex_value_error
              THEN
                -- AE 11-FEB-2009
                -- Make sure this error is raised when the Field Length/Decimal Places is out of 
                -- sync with the Unit type defined.
                -- It used to raise a unhandled Oracle PL/SQL value error
                Hig.raise_ner (pi_appl               => Nm3type.c_net
                              ,pi_id                 => 456
                              ,pi_supplementary_info => '['||l_rec_nita.ita_fld_length||'-'
                                                           ||l_rec_nita.ita_dec_places
                                                           ||'] : ['||nm3get.get_un(pi_un_unit_id => l_rec_nita.ita_units
                                                                    , pi_raise_not_found =>FALSE).un_format_mask||']'
                              );
            END;
         --
         END IF;
--
         IF l_rec_nita.ita_dec_places IS NOT NULL
          THEN
            IF l_rec_nita.ita_dec_places = 0
             THEN
               po_value := LTRIM(TO_CHAR(l_number
                                        ,c_format_string
                                        )
                                );
            ELSE
               po_value := LTRIM(TO_CHAR(l_number
                                        ,c_format_string
                                         ||'D'
                                         ||SUBSTR(c_format_string,1,l_rec_nita.ita_dec_places)
                                        )
                                );
            END IF;
         ELSE
            po_value := LTRIM(TO_CHAR(l_number));
         END IF;
--
         IF l_rec_nita.ita_format_mask IS NOT NULL
          THEN
              po_value := LTRIM(TO_CHAR(TO_NUMBER(po_value),l_rec_nita.ita_format_mask));
              IF Replace(po_value,'#') IS NULL
              THEN
                  Hig.raise_ner (pi_appl               => Nm3type.c_net
                                ,pi_id                 => 458
                                );
              END IF ;
         END IF;
--
      END;
--
   ELSIF l_rec_nita.ita_format = Nm3type.c_varchar
    THEN
--
      DECLARE
         l_out_value    VARCHAR2(4000) := NVL(l_id,pi_value);
      BEGIN
--
         -- It is not a inventory domain
         --  Just check that the string doesn't have any ' in it
         l_out_value := REPLACE(l_out_value,CHR(39),NULL);
--
         IF LENGTH(l_out_value) > l_rec_nita.ita_fld_length
          THEN
            Hig.raise_ner (pi_appl               => Nm3type.c_net
                          ,pi_id                 => 275
                          );
--            g_flex_validation_exc_code := -20703;
--            g_flex_validation_exc_msg  := 'Attribute String is too long';
--            RAISE g_flex_validation_exception;
         ELSE
            po_value := l_out_value;
         END IF;
--
      END;
----
--   ELSE
----
----   This should never happen now, as the form has a domain on it
----
--     g_flex_validation_exc_code := -20705;
--     g_flex_validation_exc_msg  := 'Invalid ITA_FORMAT specified '||l_rec_nita.ita_format;
--     RAISE g_flex_validation_exception;
----
   END IF;
--
--EXCEPTION
----
--   WHEN g_flex_validation_exception
--    THEN
--      RAISE_APPLICATION_ERROR(g_flex_validation_exc_code
--                             ,g_flex_validation_exc_msg
--                              ||'...:'||p_inv_type
--                              ||':'||p_attrib_name
--                              ||':'||pi_value
--                             );
--
END validate_flex_inv;
--
----------------------------------------------------------------------------------------------
--
FUNCTION validate_flex_inv(pi_inv_type    IN     VARCHAR2
                          ,pi_attrib_name IN     VARCHAR2
                          ,pi_value       IN     DATE
                          ,pi_bind_variable_value   IN     VARCHAR2 DEFAULT NULL
                          ) RETURN VARCHAR2 IS
BEGIN
   RETURN validate_flex_inv(pi_inv_type    => pi_inv_type
                           ,pi_attrib_name => pi_attrib_name
                           ,pi_value       => TO_CHAR(pi_value,Nm3type.c_full_date_time_format)
                           ,pi_bind_variable_value   => pi_bind_variable_value
                           );
END validate_flex_inv;
--
----------------------------------------------------------------------------------------------
--
FUNCTION validate_flex_inv(pi_inv_type    IN     VARCHAR2
                          ,pi_attrib_name IN     VARCHAR2
                          ,pi_value       IN     VARCHAR2
                          ,pi_bind_variable_value   IN     VARCHAR2 DEFAULT NULL
                          ) RETURN VARCHAR2 IS
--
   l_value   VARCHAR2(2000);
   l_meaning VARCHAR2(2000);
--
BEGIN
--
   BEGIN
      validate_flex_inv
            (p_inv_type               => pi_inv_type
            ,p_attrib_name            => pi_attrib_name
            ,pi_value                 => pi_value
            ,po_value                 => l_value
            ,po_meaning               => l_meaning
            ,pi_validate_domain_dates => FALSE
            ,pi_bind_variable_value   => pi_bind_variable_value
            );
--
      IF g_validate_flex_inv_func_rtn IN (c_meaning,c_both)
       THEN
--
         IF l_meaning IS NOT NULL
          THEN
--
            IF g_validate_flex_inv_func_rtn = c_meaning
             THEN
               l_value := l_meaning;
            ELSE
               l_value := l_meaning||' ('||l_value||')';
            END IF;
--
         END IF;
--
      END IF;
--
   EXCEPTION
      WHEN OTHERS
       THEN
         -- If validate_flex_inv raises an error, then we don't care, just return the passed value
         l_value := pi_value;
   END;
--
   RETURN l_value;
--
END validate_flex_inv;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_inv_type_attr
             (pi_inv_type    IN NM_INV_TYPE_ATTRIBS.ita_inv_type%TYPE
             ,pi_attrib_name IN NM_INV_TYPE_ATTRIBS.ita_attrib_name%TYPE
             ) RETURN NM_INV_TYPE_ATTRIBS%ROWTYPE IS
--
BEGIN
--
   RETURN Nm3get.get_ita (pi_ita_inv_type    => pi_inv_type
                         ,pi_ita_attrib_name => pi_attrib_name
                         ,pi_raise_not_found => FALSE
                         );
--
END get_inv_type_attr;
--
-----------------------------------------------------------------------------
--
FUNCTION get_all_attribs(pi_inv_type IN NM_INV_TYPE_ATTRIBS.ita_inv_type%TYPE
                        ) RETURN attrib_table IS
--
   l_attrib_tab attrib_table;
--
BEGIN
--
   FOR rec IN (SELECT ita_attrib_name
                FROM  NM_INV_TYPE_ATTRIBS
               WHERE  ita_inv_type = pi_inv_type
               ORDER BY ita_disp_seq_no
              )
    LOOP
      l_attrib_tab(l_attrib_tab.COUNT+1).attrib_name := rec.ita_attrib_name;
   END LOOP;
--
   RETURN l_attrib_tab;
--
END get_all_attribs;
--
-----------------------------------------------------------------------------
--
FUNCTION get_attrib_value(p_ne_id       IN NM_INV_ITEMS.iit_ne_id%TYPE
                         ,p_attrib_name IN NM_INV_TYPE_ATTRIBS.ita_attrib_name%TYPE
                         ) RETURN VARCHAR2 IS
--
   CURSOR c1 (p_ne_id       NM_INV_ITEMS.iit_ne_id%TYPE
             ,p_attrib_name NM_INV_TYPE_ATTRIBS.ita_attrib_name%TYPE
             ) IS
     SELECT ita_format
           ,ita_format_mask
     FROM   NM_INV_TYPE_ATTRIBS
           ,NM_INV_ITEMS
     WHERE  ita_inv_type    = iit_inv_type
      AND   iit_ne_id       = p_ne_id
      AND   ita_attrib_name = p_attrib_name;
--
   l_format NM_INV_TYPE_ATTRIBS.ita_format%TYPE;
   l_mask   NM_INV_TYPE_ATTRIBS.ita_format_mask%TYPE;
   l_retval VARCHAR2(500);
--
   l_sql_string VARCHAR2(2000);
--
BEGIN
--
   OPEN  c1 (p_ne_id, p_attrib_name);
   FETCH c1 INTO l_format, l_mask;
   CLOSE c1;
--
   IF l_format = Nm3type.c_date
    AND INSTR(p_attrib_name,l_format,1,1) != 0
    THEN
      l_sql_string := 'select to_char('
                      ||p_attrib_name
                      ||', '
                      ||Nm3flx.string(NVL(l_mask,Nm3user.get_user_date_mask))
                      ||') from nm_inv_items where iit_ne_id = :p_ne_id';
   ELSIF l_format = Nm3type.c_number
    AND  l_mask IS NOT NULL
    THEN
      l_sql_string := 'select to_char('
                      ||p_attrib_name
                      ||', '
                      ||Nm3flx.string(l_mask)
                      ||') from nm_inv_items where iit_ne_id = :p_ne_id';
   ELSE
      l_sql_string := 'select '
                      ||p_attrib_name
                      ||' from nm_inv_items where iit_ne_id = :p_ne_id';
    END IF;
--
   EXECUTE IMMEDIATE l_sql_string INTO l_retval USING p_ne_id;
--
   RETURN l_retval;
--
END get_attrib_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_all_attrib_values(p_ne_id IN NM_INV_ITEMS.iit_ne_id%TYPE)
         RETURN attrib_table IS
--
   CURSOR c1 IS
     SELECT ita_attrib_name
     FROM   NM_INV_TYPE_ATTRIBS
           ,NM_INV_ITEMS
     WHERE  iit_ne_id = p_ne_id
     AND    iit_inv_type = ita_inv_type
     ORDER BY ita_disp_seq_no;
--
   l_attrib_name NM_INV_TYPE_ATTRIBS.ita_attrib_name%TYPE;
   l_attrib_list attrib_table;
   l_attrib_count NUMBER := 0;
--
BEGIN
--
   OPEN c1;
   LOOP
     l_attrib_count := l_attrib_count+1;
     FETCH c1 INTO l_attrib_name;
     EXIT WHEN c1%NOTFOUND;
     l_attrib_list(l_attrib_count).attrib_name := l_attrib_name;
     l_attrib_list(l_attrib_count).attrib_value := get_attrib_value(p_ne_id, l_attrib_list(l_attrib_count).attrib_name);
   END LOOP;
   CLOSE c1;
--
   RETURN l_attrib_list;
--
END;
--
-----------------------------------------------------------------------------
--
FUNCTION get_all_attrib_values(p_ne_id IN NM_INV_ITEMS.iit_ne_id%TYPE
                              ,p_inv_type IN NM_INV_ITEMS.iit_inv_type%TYPE )
         RETURN attrib_table IS
--
   CURSOR c1 IS
     SELECT ita_attrib_name
     FROM   NM_INV_TYPE_ATTRIBS
           ,NM_INV_ITEMS
     WHERE  iit_ne_id = p_ne_id
     AND    iit_inv_type = p_inv_type
     AND    iit_inv_type = ita_inv_type
     ORDER BY ita_disp_seq_no;
--
   l_attrib_name NM_INV_TYPE_ATTRIBS.ita_attrib_name%TYPE;
   l_attrib_list attrib_table;
   l_attrib_count NUMBER := 0;
--
BEGIN
--
   OPEN c1;
   LOOP
     l_attrib_count := l_attrib_count+1;
     FETCH c1 INTO l_attrib_name;
     EXIT WHEN c1%NOTFOUND;
     l_attrib_list(l_attrib_count).attrib_name := l_attrib_name;
     l_attrib_list(l_attrib_count).attrib_value := get_attrib_value(p_ne_id, l_attrib_list(l_attrib_count).attrib_name);
   END LOOP;
   CLOSE c1;
--
   RETURN l_attrib_list;
--
END;
--
-----------------------------------------------------------------------------
--
FUNCTION get_attrib_scrn_text(pi_inv_type    IN NM_INV_TYPE_ATTRIBS.ita_inv_type%TYPE
                             ,pi_attrib_name IN NM_INV_TYPE_ATTRIBS.ita_attrib_name%TYPE
                             ) RETURN NM_INV_TYPE_ATTRIBS.ita_scrn_text%TYPE IS
BEGIN
--
   RETURN Nm3get.get_ita (pi_ita_inv_type    => pi_inv_type
                         ,pi_ita_attrib_name => pi_attrib_name
                         ,pi_raise_not_found => FALSE
                         ).ita_scrn_text;
--
END get_attrib_scrn_text;
--
-----------------------------------------------------------------------------
--
FUNCTION get_attrib_domain(pi_inv_type    IN NM_INV_TYPE_ATTRIBS.ita_inv_type%TYPE
                          ,pi_attrib_name IN NM_INV_TYPE_ATTRIBS.ita_attrib_name%TYPE
                          ) RETURN NM_INV_TYPE_ATTRIBS.ita_id_domain%TYPE IS
BEGIN
--
   RETURN Nm3get.get_ita (pi_ita_inv_type    => pi_inv_type
                         ,pi_ita_attrib_name => pi_attrib_name
                         ,pi_raise_not_found => FALSE
                         ).ita_id_domain;
--
END get_attrib_domain;
--
-----------------------------------------------------------------------------
--
FUNCTION get_attrib_format(pi_inv_type    IN NM_INV_TYPE_ATTRIBS.ita_inv_type%TYPE
                          ,pi_attrib_name IN NM_INV_TYPE_ATTRIBS.ita_attrib_name%TYPE
                          ) RETURN NM_INV_TYPE_ATTRIBS.ita_format%TYPE IS
BEGIN
--
   RETURN Nm3get.get_ita (pi_ita_inv_type    => pi_inv_type
                         ,pi_ita_attrib_name => pi_attrib_name
                         ,pi_raise_not_found => FALSE
                         ).ita_format;
--
END get_attrib_format;
--
-----------------------------------------------------------------------------
--
FUNCTION attrib_queryable(pi_inv_type    IN NM_INV_TYPE_ATTRIBS.ita_inv_type%TYPE
                         ,pi_attrib_name IN NM_INV_TYPE_ATTRIBS.ita_attrib_name%TYPE
                         ) RETURN BOOLEAN IS

  CURSOR c1(p_inv_type    IN NM_INV_TYPE_ATTRIBS.ita_inv_type%TYPE
           ,p_attrib_name IN NM_INV_TYPE_ATTRIBS.ita_attrib_name%TYPE) IS
    SELECT
      ita_queryable
    FROM
      NM_INV_TYPE_ATTRIBS
    WHERE
      ita_inv_type = p_inv_type
    AND
      ita_attrib_name = p_attrib_name;
  l_queryable NM_INV_TYPE_ATTRIBS.ita_queryable%TYPE;

  l_retval BOOLEAN := FALSE;

BEGIN
--
   RETURN (Nm3get.get_ita (pi_ita_inv_type    => pi_inv_type
                          ,pi_ita_attrib_name => pi_attrib_name
                          ,pi_raise_not_found => FALSE
                          ).ita_queryable
           = 'Y'
          );
--
END attrib_queryable;
--
-----------------------------------------------------------------------------
--
FUNCTION get_top_item_id(p_item_id IN NM_INV_ITEM_GROUPINGS.iig_item_id%TYPE)
         RETURN NM_INV_ITEM_GROUPINGS.iig_top_id%TYPE IS

  CURSOR c1 IS
    SELECT iig_top_id
    FROM   NM_INV_ITEM_GROUPINGS
    WHERE  iig_item_id = p_item_id;

  CURSOR c2 IS
    SELECT
      iig_top_id
    FROM
      NM_INV_ITEM_GROUPINGS
    WHERE
      iig_top_id = p_item_id;

  l_retval NM_INV_ITEM_GROUPINGS.iig_top_id%TYPE;

BEGIN

  OPEN c1;
  FETCH c1 INTO l_retval;

  IF c1%NOTFOUND THEN
    OPEN c2;
      FETCH c2 INTO l_retval;
    CLOSE c2;
  END IF;

  CLOSE c1;

  RETURN l_retval;

END get_top_item_id;
--
-----------------------------------------------------------------------------
--
FUNCTION get_inv_type(p_ne_id IN NM_INV_ITEMS.iit_ne_id%TYPE)
         RETURN NM_INV_ITEMS.iit_inv_type%TYPE IS
BEGIN
--
   RETURN get_inv_item_all(pi_ne_id => p_ne_id).iit_inv_type;
--
END get_inv_type;
--
----------------------------------------------------------------------------
--
PROCEDURE get_inv_item_details(p_ne_id IN NM_INV_ITEMS.iit_ne_id%TYPE
                              ,p_type IN OUT NM_INV_ITEMS.iit_inv_type%TYPE
                              ,p_descr IN OUT NM_INV_ITEMS.iit_descr%TYPE
                              ,p_primary IN OUT NM_INV_ITEMS.iit_primary_key%TYPE
                              ,p_xsp IN OUT NM_INV_ITEMS.iit_x_sect%TYPE) IS
--
  l_rec_iit NM_INV_ITEMS%ROWTYPE;
--
BEGIN
--
  l_rec_iit := get_inv_item(p_ne_id);
--
  p_type    := l_rec_iit.iit_inv_type;
  p_descr   := l_rec_iit.iit_descr;
  p_primary := l_rec_iit.iit_primary_key;
  p_xsp     := l_rec_iit.iit_x_sect;
--
END get_inv_item_details;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_inv_primary_key(p_ne_id IN NM_INV_ITEMS.iit_ne_id%TYPE)
         RETURN NM_INV_ITEMS.iit_primary_key%TYPE IS
--
BEGIN
--
  RETURN get_inv_item(p_ne_id).iit_primary_key;
--
END;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_inv_type (pi_inv_type IN NM_INV_TYPES.nit_inv_type%TYPE
                      ) RETURN NM_INV_TYPES%ROWTYPE IS
BEGIN
--
   RETURN Nm3get.get_nit (pi_nit_inv_type      => pi_inv_type
                         ,pi_not_found_sqlcode => -20001
                         );
--
END get_inv_type;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_inv_type_table_name( p_nit_inv_type NM_INV_TYPES.nit_inv_type%TYPE)
RETURN VARCHAR2 IS
--
BEGIN
--
   RETURN get_inv_type (p_nit_inv_type).nit_table_name;
--
END get_inv_type_table_name;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_inv_ft_details( p_nit_inv_type NM_INV_TYPES.nit_inv_type%TYPE
                            ,p_nit_table_name IN OUT NM_INV_TYPES.nit_table_name%TYPE
                            ,p_nit_lr_ne_column_name IN OUT NM_INV_TYPES.nit_lr_ne_column_name%TYPE
                            ,p_nit_lr_st_chain IN OUT NM_INV_TYPES.nit_lr_st_chain%TYPE
                            ,p_nit_lr_end_chain IN OUT NM_INV_TYPES.nit_lr_end_chain%TYPE
                           ) RETURN BOOLEAN
IS
--
   rtrn BOOLEAN := TRUE;
--
   l_rec_nit NM_INV_TYPES%ROWTYPE;
--
BEGIN
   -- Initialise return arguments
   p_nit_table_name        := NULL;
   p_nit_lr_ne_column_name := NULL;
   p_nit_lr_st_chain       := NULL;
   p_nit_lr_end_chain      := NULL;
--
   l_rec_nit := get_inv_type(p_nit_inv_type);
--
   IF l_rec_nit.nit_table_name IS NULL
    THEN
      rtrn := FALSE;
   ELSE
     p_nit_table_name        := l_rec_nit.nit_table_name;
     p_nit_lr_ne_column_name := l_rec_nit.nit_lr_ne_column_name;
     p_nit_lr_st_chain       := l_rec_nit.nit_lr_st_chain;
     p_nit_lr_end_chain      := l_rec_nit.nit_lr_end_chain;
   END IF;
--
   RETURN rtrn;
--
END get_inv_ft_details;
--
----------------------------------------------------------------------------------------------
--
FUNCTION inv_type_has_child(pi_nit_inv_type NM_INV_TYPES.nit_inv_type%TYPE
                           ) RETURN BOOLEAN IS
  CURSOR c1 IS
    SELECT
      1
    FROM
      NM_INV_TYPE_GROUPINGS
    WHERE
      itg_parent_inv_type = pi_nit_inv_type;

  l_temp PLS_INTEGER;
  l_retval BOOLEAN := FALSE;

BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'inv_type_has_child');

  OPEN c1;
    FETCH c1 INTO l_temp;
    IF c1%FOUND THEN
      l_retval := TRUE;
    END IF;
  CLOSE c1;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'inv_type_has_child');

  RETURN l_retval;

END inv_type_has_child;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_inv_item (pi_ne_id NM_INV_ITEMS.iit_ne_id%TYPE
                      ) RETURN NM_INV_ITEMS%ROWTYPE IS
BEGIN
--
   RETURN Nm3get.get_iit (pi_iit_ne_id       => pi_ne_id
                         ,pi_raise_not_found => FALSE
                         );
--
END get_inv_item;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE insert_nm_inv_items ( pi_inv_rec NM_INV_ITEMS%ROWTYPE ) IS
   l_rec_iit NM_INV_ITEMS%ROWTYPE := pi_inv_rec;
BEGIN
   Nm3ins.ins_iit (l_rec_iit);
END insert_nm_inv_items;
--
----------------------------------------------------------------------------------------------
--
   PROCEDURE copy_inv( pi_iit_ne_id NM_INV_ITEMS.iit_ne_id%TYPE
                      ,pi_iit_start_date  NM_INV_ITEMS.iit_start_date%TYPE
                      ,po_iit_ne_id OUT NM_INV_ITEMS.iit_ne_id%TYPE
                      ,pi_primary_key NM_INV_ITEMS.iit_primary_key%TYPE DEFAULT NULL
                     )
   IS
   l_rec_iit NM_INV_ITEMS%ROWTYPE;
--
   l_iit_primary_key NM_INV_ITEMS.iit_primary_key%TYPE := pi_primary_key;
--
   BEGIN
   --
      Nm_Debug.proc_start(g_package_name,'copy_inv');
   --
      -- fetch the details of the inv_item to copy
      l_rec_iit := Nm3get.get_iit (pi_iit_ne_id => pi_iit_ne_id);
--
      -- get a new iit_ne_id for it
      l_rec_iit.iit_ne_id       := Nm3net.get_next_ne_id;
      po_iit_ne_id              := l_rec_iit.iit_ne_id;
      -- set the start date to the one passed in
      l_rec_iit.iit_start_date  := pi_iit_start_date;
      l_rec_iit.iit_primary_key := NVL(l_iit_primary_key, l_rec_iit.iit_ne_id);
--
      insert_nm_inv_items ( l_rec_iit );
--
      -- nm_inv_item_groupings records are dealt with by the triggers
   --
      Nm_Debug.proc_end(g_package_name,'copy_inv');
   --
   END copy_inv;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_nm_inv_nw (pi_inv_type IN NM_INV_NW.nin_nit_inv_code%TYPE
                       ,pi_nw_type  IN NM_INV_NW.nin_nw_type%TYPE
                       ) RETURN NM_INV_NW%ROWTYPE IS
BEGIN
--
   RETURN Nm3get.get_nin (pi_nin_nit_inv_code  => pi_inv_type
                         ,pi_nin_nw_type       => pi_nw_type
                         ,pi_not_found_sqlcode => -20001
                         );
--
END get_nm_inv_nw;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE check_mand IS
--
   CURSOR cs_mand (c_inv_type NM_INV_TYPES.nit_inv_type%TYPE) IS
   SELECT *
    FROM  NM_INV_TYPE_ATTRIBS
   WHERE  ita_inv_type     = c_inv_type
    AND   ita_mandatory_yn = 'Y';
--
   l_string       VARCHAR2(32767) := 'BEGIN';
--
   l_if           VARCHAR2(10)    := '   IF  ';
--
   l_been_in_loop BOOLEAN         := FALSE;
--
BEGIN
--
   FOR cs_rec IN cs_mand (g_rec_iit.iit_inv_type)
    LOOP
      l_string := l_string||CHR(10)||l_if||'nm3inv.g_rec_iit.'||cs_rec.ita_attrib_name||' IS NULL';
      l_if := '    OR ';
      l_been_in_loop := TRUE;
   END LOOP;
--
   IF l_been_in_loop
    THEN
      l_string := l_string||CHR(10)||'    THEN'
                          ||CHR(10)||'      RAISE_APPLICATION_ERROR(-20750,'||CHR(39)||'Not all mandatory attribs populated'||CHR(39)||');'
                          ||CHR(10)||'   END IF;'
                          ||CHR(10)||'END;';
      EXECUTE IMMEDIATE l_string;
   END IF;
--
END check_mand;
--
----------------------------------------------------------------------------------------------
--
FUNCTION attrib_in_use (pi_inv_type    IN NM_INV_TYPE_ATTRIBS.ita_inv_type%TYPE
                       ,pi_attrib_name IN NM_INV_TYPE_ATTRIBS.ita_attrib_name%TYPE
                       ) RETURN BOOLEAN IS
BEGIN
--
   RETURN Nm3get.get_ita (pi_ita_inv_type    => pi_inv_type
                         ,pi_ita_attrib_name => pi_attrib_name
                         ,pi_raise_not_found => FALSE
                         ).ita_inv_type IS NOT NULL;
--
END attrib_in_use;
--
----------------------------------------------------------------------------------------------
--
FUNCTION attrib_in_use_char(pi_inv_type    IN NM_INV_TYPE_ATTRIBS.ita_inv_type%TYPE
                           ,pi_attrib_name IN NM_INV_TYPE_ATTRIBS.ita_attrib_name%TYPE
                           ) RETURN VARCHAR2 IS
BEGIN
  RETURN Nm3flx.boolean_to_char(attrib_in_use(pi_inv_type    => pi_inv_type
                                             ,pi_attrib_name => pi_attrib_name));
END attrib_in_use_char;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_inv_admin_type ( pi_inv_type NM_INV_TYPES.nit_inv_type%TYPE )
RETURN VARCHAR2 IS
BEGIN
   RETURN Nm3get.get_nit (pi_nit_inv_type    => pi_inv_type
                         ,pi_raise_not_found => FALSE
                         ).nit_admin_type;
END get_inv_admin_type;
--
----------------------------------------------------------------------------------------------
--
FUNCTION inv_location_is_mandatory(pi_inv_type IN NM_INV_TYPES.nit_inv_type%TYPE
                                  )RETURN BOOLEAN IS

  CURSOR is_loc_mand(p_inv_type IN NM_INV_TYPES.nit_inv_type%TYPE) IS
  SELECT 1
   FROM  NM_INV_NW_ALL
  WHERE  nin_loc_mandatory = 'Y'
   AND   nin_nit_inv_code  = p_inv_type;

  l_dummy  PLS_INTEGER;
  l_retval BOOLEAN;

BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'inv_location_is_mandatory');

  OPEN is_loc_mand(p_inv_type => pi_inv_type);
    FETCH is_loc_mand INTO l_dummy;
    l_retval := is_loc_mand%FOUND;
  CLOSE is_loc_mand;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'inv_location_is_mandatory');

  RETURN l_retval;

END inv_location_is_mandatory;
--
----------------------------------------------------------------------------------------------
--
FUNCTION mand_loc_inv_not_located(pi_ne_id IN NM_INV_ITEMS.iit_ne_id%TYPE
                                 )RETURN BOOLEAN IS
--
  l_retval BOOLEAN;
--
BEGIN
--
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'mand_loc_inv_not_located');

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'mand_loc_inv_not_located');

  RETURN inv_location_is_mandatory(pi_inv_type => get_inv_type(p_ne_id => pi_ne_id))
         AND
         NOT(Nm3ausec.do_locations_exist(p_ne_id => pi_ne_id));
--
END mand_loc_inv_not_located;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_const_code    RETURN VARCHAR2 IS
BEGIN
   RETURN c_code;
END get_const_code;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_const_meaning RETURN VARCHAR2 IS
BEGIN
   RETURN c_meaning;
END get_const_meaning;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_const_both    RETURN VARCHAR2 IS
BEGIN
   RETURN c_both;
END get_const_both;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE set_val_flx_inv_func_ret_type (p_val VARCHAR2) IS
BEGIN
   g_validate_flex_inv_func_rtn := p_val;
END set_val_flx_inv_func_ret_type;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_inv_item_all(pi_ne_id NM_INV_ITEMS.iit_ne_id%TYPE
                         ) RETURN NM_INV_ITEMS%ROWTYPE IS
BEGIN
--
   RETURN Nm3get.get_iit_all (pi_iit_ne_id       => pi_ne_id
                             ,pi_raise_not_found => FALSE
                             );
--
END get_inv_item_all;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_inv_type_all(p_ne_id IN NM_INV_ITEMS.iit_ne_id%TYPE
                         ) RETURN NM_INV_ITEMS.iit_inv_type%TYPE IS
--
--
   l_rec_iit NM_INV_ITEMS%ROWTYPE;
--
BEGIN
--
  l_rec_iit := get_inv_item_all(p_ne_id);
--
  RETURN l_rec_iit.iit_inv_type;
--
END get_inv_type_all;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_itg(pi_inv_type IN NM_INV_TYPES.nit_inv_type%TYPE
                ) RETURN NM_INV_TYPE_GROUPINGS%ROWTYPE IS

  CURSOR c_itg(p_inv_type        IN NM_INV_TYPES.nit_inv_type%TYPE) IS
    SELECT
      *
    FROM
      NM_INV_TYPE_GROUPINGS itg
    WHERE
      itg.itg_inv_type = p_inv_type;

  l_retval NM_INV_TYPE_GROUPINGS%ROWTYPE;

BEGIN
  OPEN c_itg(p_inv_type => pi_inv_type);
    FETCH c_itg INTO l_retval;
    IF c_itg%NOTFOUND
    THEN
      CLOSE c_itg;
      RAISE_APPLICATION_ERROR(-20009, 'nm_inv_type_groupings record not found inv_type= ' || pi_inv_type);
    END IF;
  CLOSE c_itg;

  RETURN l_retval;

END get_itg;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_ita_by_view_col (pi_inv_type      IN NM_INV_TYPE_ATTRIBS.ita_inv_type%TYPE
                             ,pi_view_col_name IN NM_INV_TYPE_ATTRIBS.ita_view_col_name%TYPE
                             ) RETURN NM_INV_TYPE_ATTRIBS%ROWTYPE IS
--
BEGIN
--
   RETURN Nm3get.get_ita (pi_ita_inv_type      => pi_inv_type
                         ,pi_ita_view_col_name => pi_view_col_name
                         ,pi_not_found_sqlcode => -20001
                         );
--
END get_ita_by_view_col;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_ita_by_attrib_name (pi_inv_type      IN NM_INV_TYPE_ATTRIBS.ita_inv_type%TYPE
                              ,pi_attrib_name IN NM_INV_TYPE_ATTRIBS.ita_attrib_name%TYPE
                             ) RETURN NM_INV_TYPE_ATTRIBS%ROWTYPE IS
--
BEGIN
--
   RETURN Nm3get.get_ita (pi_ita_inv_type    => pi_inv_type
                         ,pi_ita_attrib_name => pi_attrib_name
                         );
--
END get_ita_by_attrib_name;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_inv_mode_by_role (pi_inv_type      IN NM_INV_TYPE_ATTRIBS.ita_inv_type%TYPE
                              ,pi_username      IN user_users.username%TYPE
                              ) RETURN NM_INV_TYPE_ROLES.itr_mode%TYPE IS
--
   CURSOR cs_mode (c_inv_type NM_INV_TYPE_ATTRIBS.ita_inv_type%TYPE
                  ,c_username user_users.username%TYPE
                  ) IS
   SELECT itr_mode
    FROM  NM_INV_TYPE_ROLES
         ,HIG_USER_ROLES
   WHERE  itr_inv_type = c_inv_type
    AND   itr_hro_role = hur_role
    AND   hur_username = c_username
   ORDER BY itr_mode; -- Order so we get 'NORMAL' out before 'READONLY'
--
   l_retval NM_INV_TYPE_ROLES.itr_mode%TYPE := NULL;
--
BEGIN
--
   OPEN  cs_mode (pi_inv_type, pi_username);
   FETCH cs_mode INTO l_retval;
   CLOSE cs_mode;
--
   RETURN l_retval;
--
END get_inv_mode_by_role;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE validate_rec_iit (p_rec_iit NM_INV_ITEMS%ROWTYPE) IS
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'validate_rec_iit');
--
   g_rec_iit := p_rec_iit;
--
   validate_rec_iit;
--
   Nm_Debug.proc_start(g_package_name,'validate_rec_iit');
--
END validate_rec_iit;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE validate_rec_iit IS
--
   l_been_in_loop BOOLEAN := FALSE;
--
   l_mandatory    BOOLEAN;
--
   l_rec_nit      NM_INV_TYPES%ROWTYPE;
--
   CURSOR cs_all_xsp (c_inv_type VARCHAR2) IS
   SELECT DISTINCT xsr_x_sect_value
    FROM  XSP_RESTRAINTS
   WHERE  xsr_ity_inv_code = c_inv_type;
--
   l_tab_xsp Nm3type.tab_varchar4;
--
   l_temp_string VARCHAR2(4000);
   l_start       VARCHAR2(1) := '(';
--
   l_bind_var    NM_INV_TYPE_ATTRIBS_ALL.ita_query%TYPE;
--
   PROCEDURE append (p_text VARCHAR2) IS
   BEGIN
      Nm3ddl.append_tab_varchar(g_inv_val_tab_varchar,p_text);
   END append;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'validate_rec_iit');
--
   IF NOT g_checked_for_xav_proc
    THEN
      g_xav_procedure_exists := Nm3ddl.does_object_exist (p_object_name => Nm3inv_Xattr_Gen.c_xattr_validation_proc_name
                                                         ,p_object_type => 'PROCEDURE'
                                                         );
      g_checked_for_xav_proc := TRUE;
   END IF;

--
   IF  g_last_inv_type_dyn_val IS NULL
    OR g_last_inv_type_dyn_val != g_rec_iit.iit_inv_type
    THEN
--
      g_last_inv_type_dyn_val := g_rec_iit.iit_inv_type;
--
      l_rec_nit := get_inv_type (g_rec_iit.iit_inv_type);
   --
      g_inv_val_tab_varchar.DELETE;
   --
      append ('DECLARE');
      append ('   l_attr         nm_inv_type_attribs.ita_view_col_name%TYPE;');
      append ('   l_lup          nm_inv_attri_lookup_all.ial_meaning%TYPE;');
      append ('   l_fail_msg     VARCHAR2(2000);');
      append ('   l_fail         EXCEPTION;');
      append ('   l_notfound     EXCEPTION;');
      append ('   l_missing_mand EXCEPTION;');
      append ('   l_num_length      Varchar2(30);'); --Log 702388:Linesh:11-Mar-09:Added
      append ('   l_raise_len_error Boolean ;');     --Log 702388:Linesh:18-Mar-09:Added
      append ('   l_length          Number  ;');     --Log 702388:Linesh:18-Mar-09:Added   
      append ('   PRAGMA EXCEPTION_INIT(l_notfound,-20001);');
      append ('BEGIN');
   --
      append ('   --');
      append ('   -------------------------------------------------------------');
      append ('   -- IIT_NE_ID = '||g_rec_iit.iit_ne_id);
      append ('   -- IIT_PRIMARY_KEY = '||g_rec_iit.iit_primary_key);
      append ('   -- IIT_START_DATE = '||g_rec_iit.iit_start_date);
      append ('   -- IIT_INV_TYPE = '||g_rec_iit.iit_inv_type);
      append ('   -------------------------------------------------------------');
      append ('   --');
   --
      append ('   l_attr := '||Nm3flx.string('IIT_X_SECT')||';');
      IF l_rec_nit.nit_x_sect_allow_flag = 'Y'
       THEN
         append (' IF '||g_package_name||'.g_rec_iit.iit_x_sect IS NULL THEN');
         append ('  l_fail_msg := '||Nm3flx.string('cannot be null when XSP allowed')||'; RAISE l_fail;');
         append (' END IF;');
         --
         -- This bit of code is here to verify that the xsp specified is valid
         --
         OPEN  cs_all_xsp (l_rec_nit.nit_inv_type);
         FETCH cs_all_xsp BULK COLLECT INTO l_tab_xsp;
         CLOSE cs_all_xsp;
         --
         -- If the cursor hasn't found any xsp_restraints
         -- then raise an error, because there should be some as
         -- the inv type has been flagged as nit_x_sect_allow_flag = 'Y'
         --
         IF l_tab_xsp.COUNT = 0
          THEN
            Hig.raise_ner (pi_appl               => 'NET'
                          ,pi_id                 => 196
                          ,pi_sqlcode            => -20400
                          );
         END IF;
--
         FOR i IN 1..l_tab_xsp.COUNT
          LOOP
            l_temp_string := l_temp_string||l_start||Nm3flx.string(l_tab_xsp(i));
            l_start       := ',';
         END LOOP;
         l_temp_string := l_temp_string||')';
         append (' IF '||g_package_name||'.g_rec_iit.iit_x_sect NOT IN '||l_temp_string||' THEN');
         append ('  l_fail_msg := '||Nm3flx.string('specified value not allowed - ')||'||'||g_package_name||'.g_rec_iit.iit_x_sect; RAISE l_fail;');
         append (' END IF;');
         --
      ELSE
         append (' IF '||g_package_name||'.g_rec_iit.iit_x_sect IS NOT NULL THEN');
         append ('  l_fail_msg := '||Nm3flx.string('must be null when XSP not allowed')||'; RAISE l_fail;');
         append (' END IF;');
      END IF;
      --
      append (' l_attr := '||Nm3flx.string('IIT_ADMIN_UNIT')||';');
      --
      append (' IF nm3ausec.get_au_type('||g_package_name||'.g_rec_iit.iit_admin_unit) != '||Nm3flx.string(l_rec_nit.nit_admin_type)||' THEN');
      append ('  l_fail_msg := '||Nm3flx.string('Admin Unit not of correct type "'||l_rec_nit.nit_admin_type||'"')||'; RAISE l_fail;');
      append (' END IF;');
      --
      FOR cs_rec IN (SELECT *
                      FROM  NM_INV_TYPE_ATTRIBS
                     WHERE  ita_inv_type = g_rec_iit.iit_inv_type
                    )
       LOOP
   --
         l_been_in_loop := TRUE;
   --
         append (' l_attr := '||Nm3flx.string(cs_rec.ita_view_col_name)||';');
         --Added this code to validation the Number Attibute
         -- Log 702388:Linesh:11-Mar-09:Start
         IF cs_rec.ita_format = Nm3type.c_number
         THEN 
          -- AE
          -- Task 0108730 / 0108765
          -- Round the value before continuing
            append  (' ');
          --
            IF cs_rec.ita_dec_places IS NOT NULL
            THEN
              append  ('   '||g_package_name||'.g_rec_iit.'||cs_rec.ita_attrib_name
                            ||' := ROUND('||g_package_name||'.g_rec_iit.'||cs_rec.ita_attrib_name||','||cs_rec.ita_dec_places||');');
            END IF;
          --
            append  (' ');
          -- AE
          -- Task 0108730 / 0108765
          -- Finished
             append (' l_num_length := '||g_package_name||'.g_rec_iit.'||cs_rec.ita_attrib_name||' ;') ;
             --IF cs_rec.ita_dec_places IS NOT NULL
             --THEN
             --    append (' l_num_length := Replace(l_num_length,''.'');') ;
             --ELSE
             --    append (' IF Instr(l_num_length,''.'') > 0  THEN ');                 
             --    append (' l_num_length := substr(to_char(l_num_length),1,instr(l_num_length,''.'')-1) ; ');
             --    append (' END IF ;') ;
             --END IF;
         END IF ;
         -- Log 702388:Linesh:11-Mar-09:End
   --

         l_mandatory := cs_rec.ita_mandatory_yn = 'Y';
   --
         IF l_mandatory
          THEN
            append (' IF '||g_package_name||'.g_rec_iit.'||cs_rec.ita_attrib_name||' IS NULL THEN');
            append ('  l_fail_msg := '||Nm3flx.string('cannot be null')||'; RAISE l_missing_mand;');
            append (' END IF;');
         END IF;
       
       -- Task 0111485
       -- Only set the IIT_PRIMARY_KEY to IIT_NE_ID if it's optional, defined as a flexible attribute and it NULL.
       --
         IF NOT l_mandatory
         AND cs_rec.ita_attrib_name = 'IIT_PRIMARY_KEY'
         THEN
           append (' IF '||g_package_name||'.g_rec_iit.'||cs_rec.ita_attrib_name||' IS NULL THEN');
           append ('   '||g_package_name||'.g_rec_iit.'||cs_rec.ita_attrib_name||' := '||g_package_name||'.g_rec_iit.iit_ne_id;');
           append (' END IF;');
         END IF;
   --
         IF cs_rec.ita_id_domain IS NOT NULL
          THEN
            IF NOT l_mandatory
             THEN
               append (' IF '||g_package_name||'.g_rec_iit.'||cs_rec.ita_attrib_name||' IS NOT NULL THEN');
            END IF;
            append ('  l_lup := '||g_package_name||'.get_inv_domain_meaning('||Nm3flx.string(cs_rec.ita_id_domain)||','||g_package_name||'.g_rec_iit.'||cs_rec.ita_attrib_name||');');
            IF NOT l_mandatory
             THEN
               append (' END IF;');
            END IF;


-- GJ 24-MAY-2005
-- Plug in validation against ita_query
--
          ELSIF cs_rec.ita_query IS NOT NULL
             THEN -- Validate against query

               append ('   -- ita_query');

               append('DECLARE');
               append('  l_meaning nm3type.max_varchar2;');
               append('  l_id      nm3type.max_varchar2;');
               append('  ex_value_not_found   EXCEPTION;');
               append('	 PRAGMA EXCEPTION_INIT(ex_value_not_found,-20699);');

               append('BEGIN');
               append(' IF '||g_package_name||'.g_rec_iit.'||cs_rec.ita_attrib_name||' IS NOT NULL THEN');


               l_bind_var := Nm3flx.extract_bind_variable(cs_rec.ita_query,1);


               IF l_bind_var IS NOT NULL THEN
                 append('--');
                 append('-- The query string for this col has a bind variable so cater for it');
                 append('--');
                 append('  '||g_package_name||'.g_ita_query := nm3inv.build_ita_lov_sql_string (pi_ita_inv_type                    => '||Nm3flx.string(cs_rec.ita_inv_type));
                 append('                                                                      ,pi_ita_attrib_name                 => '||Nm3flx.string(cs_rec.ita_attrib_name));
                 append('                                                                      ,pi_include_bind_variable            => FALSE');
                 append('                                                                      ,pi_replace_bind_variable_with => '||g_package_name||'.g_rec_iit.'||REPLACE(l_bind_var,':',NULL)||');');
                 append(' ');
               ELSE
                -- Task 0109336
                -- ITA_QUERY fails if it contains apostrophes, as the ITA_QUERY was passed as literal parameter   
 --append('   '||g_package_name||'.g_ita_query := '||Nm3flx.string(cs_rec.ita_query)||';');
                 append('   '||g_package_name||'.g_ita_query := nm3get.get_ita( pi_ita_inv_type => '||Nm3flx.string(cs_rec.ita_inv_type));
                 append('                                                      ,pi_ita_attrib_name                 => '||Nm3flx.string(cs_rec.ita_attrib_name)||').ita_query ;');
               END IF;

               append(' ');
               append(' ');
               append(' ');
               append('    nm3extlov.validate_lov_value(p_statement => '||g_package_name||'.g_ita_query');
               append('                                ,p_value     => '||g_package_name||'.g_rec_iit.'||cs_rec.ita_attrib_name);
               append('                                ,p_meaning   => l_meaning');
               append('                                ,p_id        => l_id');
               append('                                ,pi_match_col => 3);');
               append(' END IF;');
               append(' ');
               append(' ');
               append(' ');

               append('EXCEPTION WHEN ex_value_not_found THEN');
               append('         hig.raise_ner(pi_appl               => nm3type.c_net');
               append('                      ,pi_id                 => 389');
               append('                      ,pi_supplementary_info => '||Nm3flx.string(cs_rec.ita_scrn_text)||'||chr(10)||nm3flx.string('||g_package_name||'.g_rec_iit.'||cs_rec.ita_attrib_name||'));');
               append('END;');
           END IF;


         IF cs_rec.ita_format = Nm3type.c_varchar
          THEN
            append (' IF LENGTH('||g_package_name||'.g_rec_iit.'||cs_rec.ita_attrib_name||') > '||cs_rec.ita_fld_length||' THEN');
            append ('  l_fail_msg := '||Nm3flx.string('cannot be more than '||cs_rec.ita_fld_length||' chars in length')||'; RAISE l_fail;');
            append (' END IF;');
            --
            -------------------------------------------------------
            -- Task 0108242
            -- AE Perform Case validation
            --
            -- Task 0109501
            -- Ignore case formatting for Domain based attributes.
            -------------------------------------------------------
            --
            IF cs_rec.ita_id_domain IS NULL
            THEN
              append (' ');
              append (' '||g_package_name||'.g_rec_iit.'||cs_rec.ita_attrib_name||' := '
                                   ||'nm3inv.format_with_ita_case ( pi_asset_type   => '||nm3flx.string(cs_rec.ita_inv_type)||
                                                                ' , pi_attrib_name  => '||nm3flx.string(cs_rec.ita_attrib_name)||
                                                                ' , pi_value        => '||g_package_name||'.g_rec_iit.'||cs_rec.ita_attrib_name||');');
              append (' ');
            END IF;

         ELSIF cs_rec.ita_format = Nm3type.c_date
          AND  INSTR(cs_rec.ita_attrib_name,cs_rec.ita_format,1,1) = 0
          THEN
         --
            append (' IF '||g_package_name||'.g_rec_iit.'||cs_rec.ita_attrib_name||' IS NOT NULL');
            append ('  THEN');
            append ('    IF hig.date_convert('||g_package_name||'.g_rec_iit.'||cs_rec.ita_attrib_name||') IS NULL');
            append ('     THEN');
            append ('      l_fail_msg := '||Nm3flx.string('cannot be evaluated as a date:')||'||'||g_package_name||'.g_rec_iit.'||cs_rec.ita_attrib_name||'; RAISE l_fail;');
            append ('    END IF;');
            append (' END IF;');
         --
         ELSIF cs_rec.ita_format = Nm3type.c_number
          THEN
            nm_debug.debug_on;
            nm_debug.debug('Validating number');
            append (' IF NOT nm3flx.is_numeric('||g_package_name||'.g_rec_iit.'||cs_rec.ita_attrib_name||') THEN');
            append ('  l_fail_msg := '||Nm3flx.string('must be numeric')||'; RAISE l_fail;');
            -- Log 702388:Linesh:11-Mar-09:Start
            append (' ELSIF 1 = 1 THEN ');
            append (' IF Instr(l_num_length,''.'') > 0  THEN ');
            append ('  l_raise_len_error := Length(substr(to_number(l_num_length),1,Instr(l_num_length,''.'')-1)) > '||cs_rec.ita_fld_length||' ; ');   
            append ('  l_length := Length(substr(to_number(l_num_length),1,Instr(l_num_length,''.'')-1));  ');                
            append (' ELSE ');
            append ('  l_raise_len_error := LENGTH(l_num_length) > '||cs_rec.ita_fld_length||' ; ');
            append ('  l_length          := LENGTH(l_num_length) ; ');
            append (' END IF ; ');
            append (' IF l_raise_len_error THEN ');
            append ('  l_fail_msg := '||Nm3flx.string('cannot be more than precision '||cs_rec.ita_fld_length||' allowed for this column')||'; RAISE l_fail;');
            append (' END IF ; ');
            append (' IF  '||Nvl(cs_rec.ita_dec_places,0)||' > 0 ');
            append (' AND Instr(l_num_length,''.'') > 0   THEN ');
            append (' IF Length(substr(l_num_length,Instr(l_num_length,''.'')+1)) > '||Nvl(cs_rec.ita_dec_places,0)||' THEN ') ;
            append ('  l_fail_msg := '||Nm3flx.string('cannot be more than precision '||cs_rec.ita_fld_length||' allowed for this column')||'; RAISE l_fail;');                 
            append (' END IF ; ') ;
            append (' END IF ; ') ;       
            --append (' ELSIF LENGTH( l_num_length ) > '||Nvl(cs_rec.ita_fld_length,22)||' THEN');
            --append ('  l_fail_msg := '||Nm3flx.string('cannot be more than precision '||cs_rec.ita_fld_length||' allowed for this column')||'; RAISE l_fail;');
            -- Log 702388:Linesh:11-Mar-09:End
            append (' END IF;');
            
            -- Task 0110456
            -- Rearranged the code so that this is called, it was previously incorrected nested in the IF statement above.
            --
            IF   cs_rec.ita_max IS NOT NULL
             AND cs_rec.ita_min IS NOT NULL
             THEN
               append (' IF '||g_package_name||'.g_rec_iit.'||cs_rec.ita_attrib_name||' IS NOT NULL');
               append ('  AND  '||g_package_name||'.g_rec_iit.'||cs_rec.ita_attrib_name||' NOT BETWEEN '||cs_rec.ita_min||' AND '||cs_rec.ita_max||' THEN');
               append ('  l_fail_msg := '||Nm3flx.string('must be between '||cs_rec.ita_min||' AND '||cs_rec.ita_max)||'; RAISE l_fail;');
               append (' END IF;');
            END IF;

         END IF;
--
      END LOOP;
--
      -- Task 0111485
      -- If IIT_PRIMARY_KEY is NULL then it has to be set to IIT_NE_ID at this point.
      -- This is because it would have already been checked in the Attributes loop if defined as flexible attribute.
      -- If it's not defined as Flex attribute then set it to IIT_NE_ID if null. 
      --
      append (' IF '||g_package_name||'.g_rec_iit.iit_primary_key IS NULL THEN');
      append ('   '||g_package_name||'.g_rec_iit.iit_primary_key'||' := '||g_package_name||'.g_rec_iit.iit_ne_id;');
      append (' END IF;');
--
      IF g_xav_procedure_exists
       THEN
         append ('--');
         append ('   '||Nm3inv_Xattr_Gen.c_xattr_validation_proc_name||'('||g_package_name||'.g_rec_iit);');
         append ('--');
      END IF;
--
      append ('EXCEPTION');
      append (' WHEN l_notfound THEN');
      append ('  RAISE_APPLICATION_ERROR(-20751,'||g_package_name||'.g_rec_iit.iit_inv_type||'||Nm3flx.string(' - ')||'||l_attr||'||Nm3flx.string(' - ')||'||SUBSTR(SQLERRM,12));');
      append (' WHEN l_fail THEN');
      append ('  RAISE_APPLICATION_ERROR(-20751,'||g_package_name||'.g_rec_iit.iit_inv_type||'||Nm3flx.string(' - ')||'||l_attr||'||Nm3flx.string(' - ')||'||l_fail_msg);');
      append (' WHEN l_missing_mand THEN');
      append ('  RAISE_APPLICATION_ERROR(-20750,'||g_package_name||'.g_rec_iit.iit_inv_type||'||Nm3flx.string(' - ')||'||l_attr||'||Nm3flx.string(' - ')||'||l_fail_msg);');
      append ('END;');
--
   END IF;
--

--nm_dbug
--nm_debug.debug_on;
--nm_debug.debug('executing validation trigger');
   nm3tab_varchar.debug_tab_varchar(g_inv_val_tab_varchar);
   Nm3ddl.execute_tab_varchar (g_inv_val_tab_varchar);
--nm_debug.debug('done executing validation trigger');
--
   Nm_Debug.proc_end(g_package_name,'validate_rec_iit');
--
END validate_rec_iit;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE ins_nit (p_rec_nit NM_INV_TYPES%ROWTYPE) IS
   l_rec_nit NM_INV_TYPES%ROWTYPE := p_rec_nit;
BEGIN
--
   Nm_Debug.proc_start(g_package_name, 'ins_nit');
--
   Nm3ins.ins_nit(l_rec_nit);
--
   Nm_Debug.proc_end(g_package_name, 'ins_nit');
--
END ins_nit;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE ins_ita (p_rec_ita NM_INV_TYPE_ATTRIBS%ROWTYPE) IS
   l_rec_ita NM_INV_TYPE_ATTRIBS%ROWTYPE := p_rec_ita;
BEGIN
--
   Nm_Debug.proc_start(g_package_name, 'ins_ita');
--
   Nm3ins.ins_ita(l_rec_ita);
--
   Nm_Debug.proc_end(g_package_name, 'ins_ita');
--
END ins_ita;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE ins_tab_ita (p_tab_ita tab_nita) IS
BEGIN
--
   Nm_Debug.proc_end(g_package_name, 'ins_tab_ita');
--
   FOR i IN 1..p_tab_ita.COUNT
    LOOP
      ins_ita (p_tab_ita(i));
   END LOOP;
--
   Nm_Debug.proc_end(g_package_name, 'ins_tab_ita');
--
END ins_tab_ita;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_attribute_value
                   (pi_ne_id    IN nm_members.nm_ne_id_of%TYPE
                   ,pi_mp       IN nm_members.nm_begin_mp%TYPE
                   ,pi_inv_type IN nm_inv_items.iit_inv_type%TYPE
                   ,pi_xsp      IN nm_inv_items.iit_x_sect%TYPE
                   ,pi_attrib   IN nm_inv_type_attribs.ita_attrib_name%TYPE
                   ) RETURN VARCHAR2 IS
--
   l_retval VARCHAR2(4000);
   l_dummy  VARCHAR2(4000);
--
   l_rec_nit nm_inv_types%ROWTYPE;
   l_rec_ita nm_inv_type_attribs%ROWTYPE;
--
   l_sql     VARCHAR2(32767);
--
   l_cur     Nm3type.ref_cursor;
--
   l_before_format VARCHAR2(2000);
   l_after_format  VARCHAR2(2000);
   l_format_mask   VARCHAR2(2000);
--
BEGIN
--
   g_datatype := NVL(g_datatype,Nm3type.c_varchar);
--
   l_rec_nit := get_inv_type (pi_inv_type);
--
   IF    l_rec_nit.nit_x_sect_allow_flag = 'Y'
    AND  pi_xsp IS NULL
    THEN
      Nm3type.g_exception_code  := -20778;
      Nm3type.g_exception_msg   := 'XSP must be specified when XSP allowed on inv_type';
      RAISE Nm3type.g_exception;
   ELSIF l_rec_nit.nit_x_sect_allow_flag = 'N'
    AND  pi_xsp IS NOT NULL
    THEN
      Nm3type.g_exception_code  := -20779;
      Nm3type.g_exception_msg   := 'XSP must not be specified when XSP not allowed on inv_type';
      RAISE Nm3type.g_exception;
   ELSIF l_rec_nit.nit_table_name IS NOT NULL
    AND  pi_xsp IS NOT NULL
    THEN
      Nm3type.g_exception_code  := -20780;
      Nm3type.g_exception_msg   := 'XSP must not be specified when inv_type uses a foreign table';
      RAISE Nm3type.g_exception;
   END IF;
--
-- passing in then attrib so get then details by then attrib_name
-- not then view_col
--   l_rec_ita := get_ita_by_view_col (pi_inv_type, pi_attrib);
--
   l_rec_ita := get_ita_by_attrib_name (pi_inv_type, pi_attrib);
--
   IF   l_rec_ita.ita_format = Nm3type.c_varchar
    AND g_datatype IN (Nm3type.c_date, Nm3type.c_number)
    THEN
      Nm3type.g_exception_code  := -20781;
      Nm3type.g_exception_msg   := 'Cannot call this function for VARCHAR2 fields';
      RAISE Nm3type.g_exception;
   END IF;
--
   IF l_rec_ita.ita_format IN (Nm3type.c_date,Nm3type.c_number)
    THEN
      l_before_format := 'TO_CHAR(';
      IF l_rec_ita.ita_format_mask IS NOT NULL
       THEN
         l_format_mask    := l_rec_ita.ita_format_mask;
      ELSIF l_rec_ita.ita_format = Nm3type.c_date
       THEN
         l_format_mask    := Nm3user.get_user_date_mask;
      END IF;
      IF l_format_mask IS NOT NULL
       THEN
         l_after_format := ','||Nm3flx.string(l_format_mask)||')';
      ELSE
         l_after_format := ')';
      END IF;
      IF g_datatype != Nm3type.c_date
       THEN
         l_format_mask    := NULL;
      ELSE
         g_last_date_mask := l_format_mask;
      END IF;
   ELSE
      g_last_date_mask := NULL;
      l_before_format  := NULL;
      l_after_format   := NULL;
   END IF;
   
    -- the sysopt = 'N' means use old code that will raise error on touching invitems
    if (nvl(hig.get_sysopt('ATTRVALUEV'),'N') = 'N') then
       l_sql :=              'SELECT '||l_before_format||l_rec_ita.ita_attrib_name||l_after_format||' '||l_rec_ita.ita_attrib_name;
       IF l_rec_nit.nit_table_name IS NULL
        THEN
             l_sql :=  l_sql
                  ||CHR(10)||' FROM  nm_inv_items'
                  ||CHR(10)||'      ,nm_members'
                  ||CHR(10)||'WHERE  nm_ne_id_of = :ne_id'
                  ||CHR(10)||' AND   nm_type     = '||Nm3flx.string('I')
                  ||CHR(10)||' AND   nm_obj_type = :inv_type'
                  ||CHR(10)||' AND   :mp BETWEEN nm_begin_mp AND nm_end_mp'
                  ||CHR(10)||' AND   nm_ne_id_in = iit_ne_id';
          IF l_rec_nit.nit_x_sect_allow_flag = 'Y'
           THEN
             l_sql :=  l_sql
                  ||CHR(10)||' AND   iit_x_sect = :xsp';
          ELSE
             l_sql :=  l_sql
                  ||CHR(10)||' AND   :xsp IS NULL';
          END IF;
       ELSE -- This is a foreign table
             l_sql :=  l_sql
                  ||CHR(10)||' FROM  '||l_rec_nit.nit_table_name
                  ||CHR(10)||'WHERE  '||l_rec_nit.nit_lr_ne_column_name||' = :ne_id'
                  ||CHR(10)||' AND   :inv_type IS NOT NULL'
                  ||CHR(10)||' AND   :mp BETWEEN '||l_rec_nit.nit_lr_st_chain||' AND '||l_rec_nit.nit_lr_end_chain
                  ||CHR(10)||' AND   :xsp IS NULL';
       END IF;
       
       OPEN  l_cur FOR  l_sql USING pi_ne_id, pi_inv_type, pi_mp, pi_xsp;
    
    
    
    
    -- use the fix to hide the first value when touching
    else
       l_sql :=              'SELECT '||l_before_format||l_rec_ita.ita_attrib_name||l_after_format||' value';
        
       IF l_rec_nit.nit_table_name IS NULL
        THEN
             l_sql :=  l_sql
                  ||chr(10)||',  row_number() over (partition by case when :mp in (nm_begin_mp, nm_end_mp) then ''Y'' end order by nm_begin_mp desc) row_num'
                  ||chr(10)||',  case when :mp in (nm_begin_mp, nm_end_mp) then ''Y'' end is_touching'
                  ||CHR(10)||' FROM  nm_inv_items'
                  ||CHR(10)||'      ,nm_members'
                  ||CHR(10)||'WHERE  nm_ne_id_of = :ne_id'
                  ||CHR(10)||' AND   nm_type     = '||Nm3flx.string('I')
                  ||CHR(10)||' AND   nm_obj_type = :inv_type'
                  ||CHR(10)||' AND   :mp BETWEEN nm_begin_mp AND nm_end_mp'
                  ||CHR(10)||' AND   nm_ne_id_in = iit_ne_id';
          IF l_rec_nit.nit_x_sect_allow_flag = 'Y'
           THEN
             l_sql :=  l_sql
                  ||CHR(10)||' AND   iit_x_sect = :xsp';
          ELSE
             l_sql :=  l_sql
                  ||CHR(10)||' AND   :xsp IS NULL';
          END IF;
       ELSE -- This is a foreign table
             l_sql :=  l_sql
                  ||chr(10)||',  row_number() over (partition by case when :mp in ('||l_rec_nit.nit_lr_st_chain||', '
                      ||l_rec_nit.nit_lr_end_chain||') then ''Y'' end order by '||l_rec_nit.nit_lr_st_chain||' desc) row_num'
                  ||chr(10)||',  case when :mp in ('||l_rec_nit.nit_lr_st_chain||', '||l_rec_nit.nit_lr_end_chain||') then ''Y'' end is_touching'
                  ||CHR(10)||' FROM  '||l_rec_nit.nit_table_name
                  ||CHR(10)||'WHERE  '||l_rec_nit.nit_lr_ne_column_name||' = :ne_id'
                  ||CHR(10)||' AND   :inv_type IS NOT NULL'
                  ||CHR(10)||' AND   :mp BETWEEN '||l_rec_nit.nit_lr_st_chain||' AND '||l_rec_nit.nit_lr_end_chain
                  ||CHR(10)||' AND   :xsp IS NULL';
       END IF;
       
       -- PT 13.06.08 log 710984: this wrapper with the added calculation columns
       --   filters out the first touching item out of two
       --   (row_num = 2 because of descending order by)
       l_sql := 
                     'select q.value'
          ||chr(10)||'from ('
          ||chr(10)||l_sql
          ||chr(10)||') q'
          ||chr(10)||'where not (q.row_num = 2 and q.is_touching = ''Y'')';
          
        OPEN  l_cur FOR  l_sql USING pi_mp, pi_mp, pi_ne_id, pi_inv_type, pi_mp, pi_xsp;
        
        
    end if;  -- end of sysopt test
 

--
   
   FETCH l_cur INTO l_retval;
   IF l_cur%NOTFOUND
    THEN
      CLOSE l_cur;
      Nm3type.g_exception_code  := -20783;
      Nm3type.g_exception_msg   := 'No inventory of this type found at this point';
      RAISE Nm3type.g_exception;
   END IF;
   FETCH l_cur INTO l_dummy;
   IF l_cur%FOUND
    THEN
      CLOSE l_cur;
      Nm3type.g_exception_code  := -20784;
      Nm3type.g_exception_msg   := '>1 inventory record of this type found at this point';
      RAISE Nm3type.g_exception;
   END IF;
   CLOSE l_cur;
--
   g_datatype := NULL;
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN Nm3type.g_exception
    THEN
      g_datatype := NULL;
      RAISE_APPLICATION_ERROR(Nm3type.g_exception_code,Nm3type.g_exception_msg);
   WHEN OTHERS
    THEN
      g_datatype := NULL;
      RAISE;
--
END get_attribute_value;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_attribute_value
                   (pi_ne_id    IN NM_MEMBERS.nm_ne_id_of%TYPE
                   ,pi_mp       IN NM_MEMBERS.nm_begin_mp%TYPE
                   ,pi_inv_type IN NM_INV_ITEMS.iit_inv_type%TYPE
                   ,pi_attrib   IN NM_INV_TYPE_ATTRIBS.ita_attrib_name%TYPE
                   ) RETURN VARCHAR2 IS
BEGIN
   RETURN get_attribute_value
                   (pi_ne_id    => pi_ne_id
                   ,pi_mp       => pi_mp
                   ,pi_inv_type => pi_inv_type
                   ,pi_xsp      => NULL
                   ,pi_attrib   => pi_attrib
                   );
END get_attribute_value;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_attribute_value_number
                   (pi_ne_id    IN NM_MEMBERS.nm_ne_id_of%TYPE
                   ,pi_mp       IN NM_MEMBERS.nm_begin_mp%TYPE
                   ,pi_inv_type IN NM_INV_ITEMS.iit_inv_type%TYPE
                   ,pi_xsp      IN NM_INV_ITEMS.iit_x_sect%TYPE
                   ,pi_attrib   IN NM_INV_TYPE_ATTRIBS.ita_attrib_name%TYPE
                   ) RETURN NUMBER IS
BEGIN
   g_datatype := Nm3type.c_number;
   RETURN TO_NUMBER(get_attribute_value
                      (pi_ne_id    => pi_ne_id
                      ,pi_mp       => pi_mp
                      ,pi_inv_type => pi_inv_type
                      ,pi_xsp      => pi_xsp
                      ,pi_attrib   => pi_attrib
                      )
                   );
END get_attribute_value_number;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_attribute_value_number
                   (pi_ne_id    IN NM_MEMBERS.nm_ne_id_of%TYPE
                   ,pi_mp       IN NM_MEMBERS.nm_begin_mp%TYPE
                   ,pi_inv_type IN NM_INV_ITEMS.iit_inv_type%TYPE
                   ,pi_attrib   IN NM_INV_TYPE_ATTRIBS.ita_attrib_name%TYPE
                   ) RETURN NUMBER IS
BEGIN
   RETURN get_attribute_value_number
                   (pi_ne_id    => pi_ne_id
                   ,pi_mp       => pi_mp
                   ,pi_inv_type => pi_inv_type
                   ,pi_xsp      => NULL
                   ,pi_attrib   => pi_attrib
                   );
END get_attribute_value_number;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_attribute_value_date
                   (pi_ne_id    IN NM_MEMBERS.nm_ne_id_of%TYPE
                   ,pi_mp       IN NM_MEMBERS.nm_begin_mp%TYPE
                   ,pi_inv_type IN NM_INV_ITEMS.iit_inv_type%TYPE
                   ,pi_xsp      IN NM_INV_ITEMS.iit_x_sect%TYPE
                   ,pi_attrib   IN NM_INV_TYPE_ATTRIBS.ita_attrib_name%TYPE
                   ) RETURN DATE IS
BEGIN
   g_datatype := Nm3type.c_date;
   RETURN TO_DATE(get_attribute_value
                      (pi_ne_id    => pi_ne_id
                      ,pi_mp       => pi_mp
                      ,pi_inv_type => pi_inv_type
                      ,pi_xsp      => pi_xsp
                      ,pi_attrib   => pi_attrib
                     )
                 ,g_last_date_mask
                 );
END get_attribute_value_date;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_attribute_value_date
                   (pi_ne_id    IN NM_MEMBERS.nm_ne_id_of%TYPE
                   ,pi_mp       IN NM_MEMBERS.nm_begin_mp%TYPE
                   ,pi_inv_type IN NM_INV_ITEMS.iit_inv_type%TYPE
                   ,pi_attrib   IN NM_INV_TYPE_ATTRIBS.ita_attrib_name%TYPE
                   ) RETURN DATE IS
BEGIN
   RETURN get_attribute_value_date
                   (pi_ne_id    => pi_ne_id
                   ,pi_mp       => pi_mp
                   ,pi_inv_type => pi_inv_type
                   ,pi_xsp      => NULL
                   ,pi_attrib   => pi_attrib
                   );
END get_attribute_value_date;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_attrib_value_view_col
                   (pi_ne_id    IN NM_MEMBERS.nm_ne_id_of%TYPE
                   ,pi_mp       IN NM_MEMBERS.nm_begin_mp%TYPE
                   ,pi_inv_type IN NM_INV_ITEMS.iit_inv_type%TYPE
                   ,pi_xsp      IN NM_INV_ITEMS.iit_x_sect%TYPE
                   ,pi_attrib   IN NM_INV_TYPE_ATTRIBS.ita_view_col_name%TYPE
                   ) RETURN VARCHAR2 IS
BEGIN
   RETURN get_attribute_value
                   (pi_ne_id    => pi_ne_id
                   ,pi_mp       => pi_mp
                   ,pi_inv_type => pi_inv_type
                   ,pi_xsp      => pi_xsp
                   ,pi_attrib   => get_ita_by_view_col(pi_inv_type, pi_attrib).ita_attrib_name
                   );
END get_attrib_value_view_col;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_attrib_value_view_col
                   (pi_ne_id    IN NM_MEMBERS.nm_ne_id_of%TYPE
                   ,pi_mp       IN NM_MEMBERS.nm_begin_mp%TYPE
                   ,pi_inv_type IN NM_INV_ITEMS.iit_inv_type%TYPE
                   ,pi_attrib   IN NM_INV_TYPE_ATTRIBS.ita_view_col_name%TYPE
                   ) RETURN VARCHAR2 IS
BEGIN
   RETURN get_attribute_value
                   (pi_ne_id    => pi_ne_id
                   ,pi_mp       => pi_mp
                   ,pi_inv_type => pi_inv_type
                   ,pi_attrib   => get_ita_by_view_col(pi_inv_type, pi_attrib).ita_attrib_name
                   );
END get_attrib_value_view_col;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_attrib_value_view_col_num
                   (pi_ne_id    IN NM_MEMBERS.nm_ne_id_of%TYPE
                   ,pi_mp       IN NM_MEMBERS.nm_begin_mp%TYPE
                   ,pi_inv_type IN NM_INV_ITEMS.iit_inv_type%TYPE
                   ,pi_xsp      IN NM_INV_ITEMS.iit_x_sect%TYPE
                   ,pi_attrib   IN NM_INV_TYPE_ATTRIBS.ita_view_col_name%TYPE
                   ) RETURN NUMBER IS
BEGIN
   RETURN get_attribute_value_number
                   (pi_ne_id    => pi_ne_id
                   ,pi_mp       => pi_mp
                   ,pi_inv_type => pi_inv_type
                   ,pi_xsp      => pi_xsp
                   ,pi_attrib   => get_ita_by_view_col(pi_inv_type, pi_attrib).ita_attrib_name
                   );
END get_attrib_value_view_col_num;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_attrib_value_view_col_num
                   (pi_ne_id    IN NM_MEMBERS.nm_ne_id_of%TYPE
                   ,pi_mp       IN NM_MEMBERS.nm_begin_mp%TYPE
                   ,pi_inv_type IN NM_INV_ITEMS.iit_inv_type%TYPE
                   ,pi_attrib   IN NM_INV_TYPE_ATTRIBS.ita_view_col_name%TYPE
                   ) RETURN NUMBER IS
BEGIN
   RETURN get_attribute_value_number
                   (pi_ne_id    => pi_ne_id
                   ,pi_mp       => pi_mp
                   ,pi_inv_type => pi_inv_type
                   ,pi_attrib   => get_ita_by_view_col(pi_inv_type, pi_attrib).ita_attrib_name
                   );
END get_attrib_value_view_col_num;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_attrib_value_view_col_date
                   (pi_ne_id    IN NM_MEMBERS.nm_ne_id_of%TYPE
                   ,pi_mp       IN NM_MEMBERS.nm_begin_mp%TYPE
                   ,pi_inv_type IN NM_INV_ITEMS.iit_inv_type%TYPE
                   ,pi_xsp      IN NM_INV_ITEMS.iit_x_sect%TYPE
                   ,pi_attrib   IN NM_INV_TYPE_ATTRIBS.ita_view_col_name%TYPE
                   ) RETURN DATE IS
BEGIN
   RETURN get_attribute_value_date
                   (pi_ne_id    => pi_ne_id
                   ,pi_mp       => pi_mp
                   ,pi_inv_type => pi_inv_type
                   ,pi_xsp      => pi_xsp
                   ,pi_attrib   => get_ita_by_view_col(pi_inv_type, pi_attrib).ita_attrib_name
                   );
END get_attrib_value_view_col_date;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_attrib_value_view_col_date
                   (pi_ne_id    IN NM_MEMBERS.nm_ne_id_of%TYPE
                   ,pi_mp       IN NM_MEMBERS.nm_begin_mp%TYPE
                   ,pi_inv_type IN NM_INV_ITEMS.iit_inv_type%TYPE
                   ,pi_attrib   IN NM_INV_TYPE_ATTRIBS.ita_view_col_name%TYPE
                   ) RETURN DATE IS
BEGIN
   RETURN get_attribute_value_date
                   (pi_ne_id    => pi_ne_id
                   ,pi_mp       => pi_mp
                   ,pi_inv_type => pi_inv_type
                   ,pi_attrib   => get_ita_by_view_col(pi_inv_type, pi_attrib).ita_attrib_name
                   );
END get_attrib_value_view_col_date;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE delete_inv_items(pi_inv_type        IN NM_INV_TYPES.nit_inv_type%TYPE
                          ,pi_cascade         IN BOOLEAN  DEFAULT FALSE
                          ,pi_where           IN VARCHAR2 DEFAULT NULL
                          ,pi_inv_table_alias IN VARCHAR2 DEFAULT 'iit'
                          ) IS

  e_children_and_no_cascade EXCEPTION;
  e_cascade_and_where       EXCEPTION;

  c_nl CONSTANT VARCHAR2(1) := CHR(10);

  CURSOR cs_child_types(p_parent_type NM_INV_TYPE_GROUPINGS_ALL.itg_parent_inv_type%TYPE
                       ) IS
    SELECT
      itg.itg_inv_type child_type
    FROM
      NM_INV_TYPE_GROUPINGS_ALL itg
    WHERE
      itg.itg_parent_inv_type = p_parent_type
    AND
      itg_mandatory = 'N';

  l_lock_qry           Nm3type.max_varchar2;
  l_children_exist_qry Nm3type.max_varchar2;

--   TYPE t_rowid IS RECORD(r1 rowid, r2 rowid, r3 rowid);
--   TYPE t_ref_cur IS REF CURSOR RETURN t_rowid;
--
--   cs_lock           t_ref_cur;

  cs_lock           Nm3type.ref_cursor;
  cs_children_exist Nm3type.ref_cursor;

  l_iit_rowid_tab Nm3type.tab_rowid;
  l_iig_rowid_tab Nm3type.tab_rowid;
  l_nm_rowid_tab  Nm3type.tab_rowid;

  l_dummy PLS_INTEGER;
  l_children BOOLEAN;

  l_i PLS_INTEGER;

BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'delete_inv_items');

  --NB: No security checked in this procedure.
  --    User may not be able to see the inv they are trying to delete.
  --    Calling context should check this if necessary.

  --currently cannot cascade to children when there is a where clause specified
  --because the recursive call will delete all items in the child type not just
  --the children of those matching the where.
  IF pi_cascade
    AND pi_where IS NOT NULL
  THEN
    RAISE e_cascade_and_where;
  END IF;

  ------------------------------
  --check hierarchy for children
  ------------------------------
  IF inv_type_has_child(pi_nit_inv_type => pi_inv_type)
  THEN
    l_children_exist_qry :=           'SELECT'
                           || c_nl || '  1'
                           || c_nl || 'FROM'
                           || c_nl || '  dual'
                           || c_nl || 'WHERE EXISTS(SELECT'
                           || c_nl || '               1'
                           || c_nl || '             FROM'
                           || c_nl || '               nm_inv_items_all          ' || pi_inv_table_alias || ','
                           || c_nl || '               nm_inv_item_groupings_all iig'
                           || c_nl || '             WHERE'
                           || c_nl || '               ' || pi_inv_table_alias || '.iit_inv_type = ' || Nm3flx.string(pi_string => pi_inv_type)
                           || c_nl || '             AND'
                           || c_nl || '               iig.iig_parent_id = ' || pi_inv_table_alias || '.iit_ne_id';

    IF pi_where IS NOT NULL
    THEN
      l_children_exist_qry :=            l_children_exist_qry
                              || c_nl || 'AND'
                              || c_nl || '  ' || pi_where;
    END IF;

    l_children_exist_qry := l_children_exist_qry || ')';

    OPEN cs_children_exist FOR l_children_exist_qry;
      FETCH cs_children_exist INTO l_dummy;
      l_children := cs_children_exist%FOUND;
    CLOSE cs_children_exist;

    IF l_children
      AND NOT(pi_cascade)
    THEN
      RAISE e_children_and_no_cascade;
    END IF;
  END IF;

  -------------------------------------
  --get and lock ids of items to delete
  -------------------------------------
  l_lock_qry :=            'SELECT'
                || c_nl || '  ' || pi_inv_table_alias || '.rowid,'
                || c_nl || '  iig.rowid,'
                || c_nl || '  nm.rowid'
                || c_nl || 'FROM'
                || c_nl || '  nm_inv_items_all          ' || pi_inv_table_alias || ','
                || c_nl || '  nm_inv_item_groupings_all iig,'
                || c_nl || '  nm_members_all            nm'
                || c_nl || 'WHERE'
                || c_nl || '  ' || pi_inv_table_alias || '.iit_inv_type = ' || Nm3flx.string(pi_string => pi_inv_type)
                || c_nl || 'AND'
                || c_nl || '  nm.nm_ne_id_in (+) = ' || pi_inv_table_alias || '.iit_ne_id'
                || c_nl || 'AND'
                || c_nl || '  iig.iig_item_id (+) = ' || pi_inv_table_alias || '.iit_ne_id';

  IF pi_where IS NOT NULL
  THEN
    l_lock_qry :=            l_lock_qry
                  || c_nl || 'AND'
                  || c_nl || '  ' || pi_where;
  END IF;

  l_lock_qry :=            l_lock_qry
                || c_nl || 'FOR UPDATE NOWAIT';

--cannot use bulk collect with dynamic sql apparently
--   OPEN cs_lock FOR l_lock_qry;
--     FETCH cs_lock BULK COLLECT INTO l_iit_rowid_tab,
--                                     l_iig_rowid_tab,
--                                     l_nm_rowid_tab;
--   CLOSE cs_lock;

  l_i := 0;

  OPEN cs_lock FOR l_lock_qry;
  LOOP
    l_i := l_i + 1;

    FETCH cs_lock INTO l_iit_rowid_tab(l_i),
                       l_iig_rowid_tab(l_i),
                       l_nm_rowid_tab(l_i);

    EXIT WHEN cs_lock%NOTFOUND;
  END LOOP;
  CLOSE cs_lock;

  -----------------------------
  --recursivley delete children
  -----------------------------
  IF l_children
  THEN
    FOR l_rec IN cs_child_types(p_parent_type => pi_inv_type)
    LOOP
      delete_inv_items(pi_inv_type => l_rec.child_type
                      ,pi_cascade  => pi_cascade);
    END LOOP;
  END IF;

  -------------------------------
  --delete nm_members_all records
  -------------------------------
  FORALL l_i IN 1..l_nm_rowid_tab.COUNT
    DELETE
      NM_MEMBERS_ALL
    WHERE
      ROWID = l_nm_rowid_tab(l_i);

  ------------------------------------------
  --delete nm_inv_item_groupings_all records
  ------------------------------------------
  FORALL l_i IN 1..l_iig_rowid_tab.COUNT
    DELETE
      NM_INV_ITEM_GROUPINGS_ALL
    WHERE
      ROWID = l_iig_rowid_tab(l_i);

  -----------------------------------------
  --lastly, delete nm_inv_items_all records
  -----------------------------------------
  FORALL l_i IN 1..l_iit_rowid_tab.COUNT
    DELETE
      NM_INV_ITEMS_ALL
    WHERE
      ROWID = l_iit_rowid_tab(l_i);

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'delete_inv_items');

EXCEPTION
  WHEN e_cascade_and_where
  THEN
    Hig.raise_ner(pi_appl               => 'NET'
                 ,pi_id                 => 198
                 ,pi_sqlcode            => -20711
                 ,pi_supplementary_info => NULL);

  WHEN e_children_and_no_cascade
  THEN
    Hig.raise_ner(pi_appl               => 'NET'
                 ,pi_id                 => 197
                 ,pi_sqlcode            => -20710
                 ,pi_supplementary_info => '(' || pi_inv_type || ')');

END delete_inv_items;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE set_inv_warning_msg (p_msg VARCHAR2) IS
BEGIN
   g_inv_warning_msg := p_msg;
END set_inv_warning_msg;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_inv_warning_msg RETURN VARCHAR2 IS
BEGIN
   RETURN g_inv_warning_msg;
END get_inv_warning_msg;
--
----------------------------------------------------------------------------------------------
--
FUNCTION nm_inv_domain_exists (p_id_domain  NM_INV_DOMAINS_ALL.id_domain%TYPE) RETURN BOOLEAN IS
--
   CURSOR cs_id (c_id NM_INV_DOMAINS_ALL.id_domain%TYPE) IS
   SELECT 1
    FROM  NM_INV_DOMAINS_ALL
   WHERE  id_domain = c_id;
--
   l_dummy  PLS_INTEGER;
   l_retval BOOLEAN;
--
BEGIN
--
   OPEN  cs_id (p_id_domain);
   FETCH cs_id INTO l_dummy;
   l_retval := cs_id%FOUND;
   CLOSE cs_id;
--
   RETURN l_retval;
--
END nm_inv_domain_exists;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE duplicate_hdo_as_id (p_hdo_domain    HIG_DOMAINS.hdo_domain%TYPE
                              ,p_id_start_date NM_INV_DOMAINS_ALL.id_start_date%TYPE
                              ,p_id_domain     NM_INV_DOMAINS_ALL.id_domain%TYPE DEFAULT NULL
                              ) IS
--
   l_id_domain NM_INV_DOMAINS_ALL.id_domain%TYPE := NVL(p_id_domain,p_hdo_domain);
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'duplicate_hdo_as_id');
--
   IF NOT Hig.domain_exists (p_hdo_domain)
    THEN
      Hig.raise_ner (pi_appl                => Nm3type.c_hig
                    ,pi_id                  => 67
                    ,pi_supplementary_info  => 'HIG_DOMAINS : '||p_hdo_domain
                    );
   ELSIF nm_inv_domain_exists (l_id_domain)
    THEN
      Hig.raise_ner (pi_appl                => Nm3type.c_hig
                    ,pi_id                  => 64
                    ,pi_supplementary_info  => 'NM_INV_DOMAINS : '||l_id_domain
                    );
   END IF;
--
   INSERT INTO NM_INV_DOMAINS
         (id_domain
         ,id_title
         ,id_start_date
         ,id_end_date
         )
   SELECT l_id_domain
         ,hdo_title
         ,p_id_start_date
         ,NULL
    FROM  HIG_DOMAINS
   WHERE  hdo_domain = p_hdo_domain;
--
   INSERT INTO NM_INV_ATTRI_LOOKUP
         (ial_domain
         ,ial_value
         ,ial_dtp_code
         ,ial_meaning
         ,ial_start_date
         ,ial_end_date
         ,ial_seq
         )
   SELECT l_id_domain
         ,hco_code
         ,NULL
         ,hco_meaning
         ,p_id_start_date
         ,NULL
         ,NVL(hco_seq,ROWNUM)
    FROM  HIG_CODES
   WHERE  hco_domain = p_hdo_domain;
--
   Nm_Debug.proc_end(g_package_name,'duplicate_hdo_as_id');
--
END duplicate_hdo_as_id;
--
----------------------------------------------------------------------------------------------
--
FUNCTION duplicate_hdo_as_id (p_hdo_domain      HIG_DOMAINS.hdo_domain%TYPE
                             ,p_id_start_date   NM_INV_DOMAINS_ALL.id_start_date%TYPE
                             ,p_optional_prefix NM_INV_TYPES.nit_inv_type%TYPE
                             ) RETURN NM_INV_DOMAINS_ALL.id_domain%TYPE IS
--
   CURSOR cs_hdo (c_domain HIG_DOMAINS.hdo_domain%TYPE) IS
   SELECT *
    FROM  HIG_DOMAINS
   WHERE  hdo_domain = c_domain;
--
   CURSOR cs_id (c_domain NM_INV_DOMAINS_ALL.id_domain%TYPE) IS
   SELECT *
    FROM  NM_INV_DOMAINS_ALL
   WHERE  id_domain  = c_domain;
--
   l_rec_hdo  HIG_DOMAINS%ROWTYPE;
   l_rec_id   NM_INV_DOMAINS_ALL%ROWTYPE;
   l_id_found BOOLEAN;
--
   l_id_domain NM_INV_DOMAINS_ALL.id_domain%TYPE;
--
   l_create    BOOLEAN;
--
BEGIN
--
   OPEN  cs_hdo (p_hdo_domain);
   FETCH cs_hdo INTO l_rec_hdo;
   IF cs_hdo%NOTFOUND
    THEN
      Hig.raise_ner (pi_appl                => Nm3type.c_hig
                    ,pi_id                  => 67
                    ,pi_supplementary_info  => 'HIG_DOMAINS : '||p_hdo_domain
                    );
      CLOSE cs_hdo;
   END IF;
   CLOSE cs_hdo;
--
   OPEN  cs_id  (p_hdo_domain);
   FETCH cs_id INTO l_rec_id;
   l_id_found := cs_id%FOUND;
   CLOSE cs_id;
--
   l_id_domain := p_hdo_domain;
   IF l_id_found
    THEN
      IF UPPER(l_rec_id.id_title) = UPPER(l_rec_hdo.hdo_title)
       THEN -- These domains are the same
         l_create := FALSE;
      ELSE
         l_create := TRUE;
         l_id_domain := p_optional_prefix||'_'||l_id_domain;
      END IF;
   ELSE
      l_create := TRUE;
   END IF;
--
   IF l_create
    THEN
      duplicate_hdo_as_id (p_hdo_domain    => p_hdo_domain
                          ,p_id_start_date => p_id_start_date
                          ,p_id_domain     => l_id_domain
                          );
   END IF;
--
   RETURN l_id_domain;
--
END duplicate_hdo_as_id;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE check_inv_format_against_col (p_column_name VARCHAR2
                                       ,p_format      VARCHAR2
                                       ,p_inv_type    VARCHAR2 DEFAULT NULL
                                       ) IS
--
   CURSOR cs_atc (p_owner  VARCHAR2
                 ,p_table  VARCHAR2
                 ,p_column VARCHAR2
                 ) IS
   SELECT data_type
    FROM  all_tab_columns
   WHERE  owner       = p_owner
    AND   table_name  = p_table
    AND   column_name = p_column;
--
   l_table_name all_tab_columns.table_name%TYPE;
   l_data_type  all_tab_columns.data_type%TYPE;
--
BEGIN
--   raise_application_error(-20555,p_column_name||':'||p_format||':'||p_inv_type);
--
   DECLARE
      l_col_not_found   EXCEPTION;
      l_data_not_passed EXCEPTION;
      l_invalid_format  EXCEPTION;
   BEGIN
   --
      IF  p_column_name IS NULL
       OR p_format      IS NULL
       THEN
         RAISE l_data_not_passed;
      END IF;
   --
      IF p_inv_type IS NOT NULL
       THEN
         l_table_name := get_inv_type(p_inv_type).nit_table_name;
      END IF;
      l_table_name := NVL(l_table_name,'NM_INV_ITEMS_ALL');
   --
      OPEN  cs_atc (Hig.get_application_owner
                   ,l_table_name
                   ,p_column_name
                   );
      FETCH cs_atc INTO l_data_type;
      IF cs_atc%NOTFOUND
       THEN
         CLOSE cs_atc;
         RAISE l_col_not_found;
      END IF;
      CLOSE cs_atc;
      --
      IF    p_format     = Nm3type.c_varchar
       AND  l_data_type != Nm3type.c_varchar
       THEN
         RAISE l_invalid_format;
      ELSIF p_format     = Nm3type.c_date
       AND  l_data_type  = Nm3type.c_number
       THEN
         RAISE l_invalid_format;
      ELSIF p_format     = Nm3type.c_number
       AND  l_data_type  = Nm3type.c_date
       THEN
         RAISE l_invalid_format;
      END IF;
      --
   EXCEPTION
      WHEN l_col_not_found
       THEN
         Hig.raise_ner(pi_appl               => Nm3type.c_net
                      ,pi_id                 => 223
                      ,pi_supplementary_info => l_table_name||'.'||p_column_name
                      );
      WHEN l_data_not_passed
       THEN
         NULL;
      WHEN l_invalid_format
       THEN
         Hig.raise_ner(pi_appl               => Nm3type.c_net
                      ,pi_id                 => 222
                      ,pi_supplementary_info => p_format||':'||l_data_type
                      );
   END;
--
END check_inv_format_against_col;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE instantiate_flex_cols IS
--
-- This procedure contains all of the NM_INV_ITEMS_ALL
--  columns which are valid to be used as flexible columns in NM_INV_TYPE_ATTRIBS
-- The array position used is that of the COLUMN_ID in user_tab_columns

--
BEGIN
--
   g_tab_flex_col(3)   := 'IIT_PRIMARY_KEY';
   g_tab_flex_col(12)  := 'IIT_FOREIGN_KEY';
   g_tab_flex_col(14)  := 'IIT_POSITION';
   g_tab_flex_col(15)  := 'IIT_X_COORD';
   g_tab_flex_col(16)  := 'IIT_Y_COORD';
   g_tab_flex_col(17)  := 'IIT_NUM_ATTRIB16';
   g_tab_flex_col(18)  := 'IIT_NUM_ATTRIB17';
   g_tab_flex_col(19)  := 'IIT_NUM_ATTRIB18';
   g_tab_flex_col(20)  := 'IIT_NUM_ATTRIB19';
   g_tab_flex_col(21)  := 'IIT_NUM_ATTRIB20';
   g_tab_flex_col(22)  := 'IIT_NUM_ATTRIB21';
   g_tab_flex_col(23)  := 'IIT_NUM_ATTRIB22';
   g_tab_flex_col(24)  := 'IIT_NUM_ATTRIB23';
   g_tab_flex_col(25)  := 'IIT_NUM_ATTRIB24';
   g_tab_flex_col(26)  := 'IIT_NUM_ATTRIB25';
   g_tab_flex_col(27)  := 'IIT_CHR_ATTRIB26';
   g_tab_flex_col(28)  := 'IIT_CHR_ATTRIB27';
   g_tab_flex_col(29)  := 'IIT_CHR_ATTRIB28';
   g_tab_flex_col(30)  := 'IIT_CHR_ATTRIB29';
   g_tab_flex_col(31)  := 'IIT_CHR_ATTRIB30';
   g_tab_flex_col(32)  := 'IIT_CHR_ATTRIB31';
   g_tab_flex_col(33)  := 'IIT_CHR_ATTRIB32';
   g_tab_flex_col(34)  := 'IIT_CHR_ATTRIB33';
   g_tab_flex_col(35)  := 'IIT_CHR_ATTRIB34';
   g_tab_flex_col(36)  := 'IIT_CHR_ATTRIB35';
   g_tab_flex_col(37)  := 'IIT_CHR_ATTRIB36';
   g_tab_flex_col(38)  := 'IIT_CHR_ATTRIB37';
   g_tab_flex_col(39)  := 'IIT_CHR_ATTRIB38';
   g_tab_flex_col(40)  := 'IIT_CHR_ATTRIB39';
   g_tab_flex_col(41)  := 'IIT_CHR_ATTRIB40';
   g_tab_flex_col(42)  := 'IIT_CHR_ATTRIB41';
   g_tab_flex_col(43)  := 'IIT_CHR_ATTRIB42';
   g_tab_flex_col(44)  := 'IIT_CHR_ATTRIB43';
   g_tab_flex_col(45)  := 'IIT_CHR_ATTRIB44';
   g_tab_flex_col(46)  := 'IIT_CHR_ATTRIB45';
   g_tab_flex_col(47)  := 'IIT_CHR_ATTRIB46';
   g_tab_flex_col(48)  := 'IIT_CHR_ATTRIB47';
   g_tab_flex_col(49)  := 'IIT_CHR_ATTRIB48';
   g_tab_flex_col(50)  := 'IIT_CHR_ATTRIB49';
   g_tab_flex_col(51)  := 'IIT_CHR_ATTRIB50';
   g_tab_flex_col(52)  := 'IIT_CHR_ATTRIB51';
   g_tab_flex_col(53)  := 'IIT_CHR_ATTRIB52';
   g_tab_flex_col(54)  := 'IIT_CHR_ATTRIB53';
   g_tab_flex_col(55)  := 'IIT_CHR_ATTRIB54';
   g_tab_flex_col(56)  := 'IIT_CHR_ATTRIB55';
   g_tab_flex_col(57)  := 'IIT_CHR_ATTRIB56';
   g_tab_flex_col(58)  := 'IIT_CHR_ATTRIB57';
   g_tab_flex_col(59)  := 'IIT_CHR_ATTRIB58';
   g_tab_flex_col(60)  := 'IIT_CHR_ATTRIB59';
   g_tab_flex_col(61)  := 'IIT_CHR_ATTRIB60';
   g_tab_flex_col(62)  := 'IIT_CHR_ATTRIB61';
   g_tab_flex_col(63)  := 'IIT_CHR_ATTRIB62';
   g_tab_flex_col(64)  := 'IIT_CHR_ATTRIB63';
   g_tab_flex_col(65)  := 'IIT_CHR_ATTRIB64';
   g_tab_flex_col(66)  := 'IIT_CHR_ATTRIB65';
   g_tab_flex_col(67)  := 'IIT_CHR_ATTRIB66';
   g_tab_flex_col(68)  := 'IIT_CHR_ATTRIB67';
   g_tab_flex_col(69)  := 'IIT_CHR_ATTRIB68';
   g_tab_flex_col(70)  := 'IIT_CHR_ATTRIB69';
   g_tab_flex_col(71)  := 'IIT_CHR_ATTRIB70';
   g_tab_flex_col(72)  := 'IIT_CHR_ATTRIB71';
   g_tab_flex_col(73)  := 'IIT_CHR_ATTRIB72';
   g_tab_flex_col(74)  := 'IIT_CHR_ATTRIB73';
   g_tab_flex_col(75)  := 'IIT_CHR_ATTRIB74';
   g_tab_flex_col(76)  := 'IIT_CHR_ATTRIB75';
   g_tab_flex_col(77)  := 'IIT_NUM_ATTRIB76';
   g_tab_flex_col(78)  := 'IIT_NUM_ATTRIB77';
   g_tab_flex_col(79)  := 'IIT_NUM_ATTRIB78';
   g_tab_flex_col(80)  := 'IIT_NUM_ATTRIB79';
   g_tab_flex_col(81)  := 'IIT_NUM_ATTRIB80';
   g_tab_flex_col(82)  := 'IIT_NUM_ATTRIB81';
   g_tab_flex_col(83)  := 'IIT_NUM_ATTRIB82';
   g_tab_flex_col(84)  := 'IIT_NUM_ATTRIB83';
   g_tab_flex_col(85)  := 'IIT_NUM_ATTRIB84';
   g_tab_flex_col(86)  := 'IIT_NUM_ATTRIB85';
   g_tab_flex_col(87)  := 'IIT_DATE_ATTRIB86';
   g_tab_flex_col(88)  := 'IIT_DATE_ATTRIB87';
   g_tab_flex_col(89)  := 'IIT_DATE_ATTRIB88';
   g_tab_flex_col(90)  := 'IIT_DATE_ATTRIB89';
   g_tab_flex_col(91)  := 'IIT_DATE_ATTRIB90';
   g_tab_flex_col(92)  := 'IIT_DATE_ATTRIB91';
   g_tab_flex_col(93)  := 'IIT_DATE_ATTRIB92';
   g_tab_flex_col(94)  := 'IIT_DATE_ATTRIB93';
   g_tab_flex_col(95)  := 'IIT_DATE_ATTRIB94';
   g_tab_flex_col(96)  := 'IIT_DATE_ATTRIB95';
   g_tab_flex_col(97)  := 'IIT_ANGLE';
   g_tab_flex_col(98)  := 'IIT_ANGLE_TXT';
   g_tab_flex_col(99)  := 'IIT_CLASS';
   g_tab_flex_col(100) := 'IIT_CLASS_TXT';
   g_tab_flex_col(101) := 'IIT_COLOUR';
   g_tab_flex_col(102) := 'IIT_COLOUR_TXT';
   g_tab_flex_col(103) := 'IIT_COORD_FLAG';
   g_tab_flex_col(104) := 'IIT_DESCRIPTION';
   g_tab_flex_col(105) := 'IIT_DIAGRAM';
   g_tab_flex_col(106) := 'IIT_DISTANCE';
   g_tab_flex_col(107) := 'IIT_END_CHAIN';
   g_tab_flex_col(108) := 'IIT_GAP';
   g_tab_flex_col(109) := 'IIT_HEIGHT';
   g_tab_flex_col(110) := 'IIT_HEIGHT_2';
   g_tab_flex_col(111) := 'IIT_ID_CODE';
   g_tab_flex_col(112) := 'IIT_INSTAL_DATE';
   g_tab_flex_col(113) := 'IIT_INVENT_DATE';
   g_tab_flex_col(114) := 'IIT_INV_OWNERSHIP';
   g_tab_flex_col(115) := 'IIT_ITEMCODE';
   g_tab_flex_col(116) := 'IIT_LCO_LAMP_CONFIG_ID';
   g_tab_flex_col(117) := 'IIT_LENGTH';
   g_tab_flex_col(118) := 'IIT_MATERIAL';
   g_tab_flex_col(119) := 'IIT_MATERIAL_TXT';
   g_tab_flex_col(120) := 'IIT_METHOD';
   g_tab_flex_col(121) := 'IIT_METHOD_TXT';
--   g_tab_flex_col(122) := 'IIT_NOTE';
   g_tab_flex_col(123) := 'IIT_NO_OF_UNITS';
   g_tab_flex_col(124) := 'IIT_OPTIONS';
   g_tab_flex_col(125) := 'IIT_OPTIONS_TXT';
   g_tab_flex_col(126) := 'IIT_OUN_ORG_ID_ELEC_BOARD';
   g_tab_flex_col(127) := 'IIT_OWNER';
   g_tab_flex_col(128) := 'IIT_OWNER_TXT';
-- g_tab_flex_col(129) := 'IIT_PEO_INVENT_BY_ID';
   g_tab_flex_col(130) := 'IIT_PHOTO';
   g_tab_flex_col(131) := 'IIT_POWER';
   g_tab_flex_col(132) := 'IIT_PROV_FLAG';
   g_tab_flex_col(133) := 'IIT_REV_BY';
   g_tab_flex_col(134) := 'IIT_REV_DATE';
   g_tab_flex_col(135) := 'IIT_TYPE';
   g_tab_flex_col(136) := 'IIT_TYPE_TXT';
   g_tab_flex_col(137) := 'IIT_WIDTH';
   g_tab_flex_col(138) := 'IIT_XTRA_CHAR_1';
   g_tab_flex_col(139) := 'IIT_XTRA_DATE_1';
   g_tab_flex_col(140) := 'IIT_XTRA_DOMAIN_1';
   g_tab_flex_col(141) := 'IIT_XTRA_DOMAIN_TXT_1';
   g_tab_flex_col(142) := 'IIT_XTRA_NUMBER_1';
-- g_tab_flex_col(144) := 'IIT_DET_XSP';
   g_tab_flex_col(145) := 'IIT_OFFSET';
   g_tab_flex_col(146) := 'IIT_X';
   g_tab_flex_col(147) := 'IIT_Y';
   g_tab_flex_col(148) := 'IIT_Z';
   g_tab_flex_col(149) := 'IIT_NUM_ATTRIB96';
   g_tab_flex_col(150) := 'IIT_NUM_ATTRIB97';
   g_tab_flex_col(151) := 'IIT_NUM_ATTRIB98';
   g_tab_flex_col(152) := 'IIT_NUM_ATTRIB99';
   g_tab_flex_col(153) := 'IIT_NUM_ATTRIB100';
   g_tab_flex_col(154) := 'IIT_NUM_ATTRIB101';
   g_tab_flex_col(155) := 'IIT_NUM_ATTRIB102';
   g_tab_flex_col(156) := 'IIT_NUM_ATTRIB103';
   g_tab_flex_col(157) := 'IIT_NUM_ATTRIB104';
   g_tab_flex_col(158) := 'IIT_NUM_ATTRIB105';
   g_tab_flex_col(159) := 'IIT_NUM_ATTRIB106';
   g_tab_flex_col(160) := 'IIT_NUM_ATTRIB107';
   g_tab_flex_col(161) := 'IIT_NUM_ATTRIB108';
   g_tab_flex_col(162) := 'IIT_NUM_ATTRIB109';
   g_tab_flex_col(163) := 'IIT_NUM_ATTRIB110';
   g_tab_flex_col(164) := 'IIT_NUM_ATTRIB111';
   g_tab_flex_col(165) := 'IIT_NUM_ATTRIB112';
   g_tab_flex_col(166) := 'IIT_NUM_ATTRIB113';
   g_tab_flex_col(167) := 'IIT_NUM_ATTRIB114';
   g_tab_flex_col(168) := 'IIT_NUM_ATTRIB115';
--
END instantiate_flex_cols;
--
----------------------------------------------------------------------------------------------
--

FUNCTION is_column_allowable_for_flex (p_column_name user_tab_columns.column_name%TYPE) RETURN VARCHAR2 IS
--
   l_retval VARCHAR2(5) := Nm3type.c_false;
   i        PLS_INTEGER;
--
BEGIN
--
   i := g_tab_flex_col.FIRST;
--
   WHILE i IS NOT NULL
    LOOP
      IF g_tab_flex_col(i) = p_column_name
       THEN
         l_retval := Nm3type.c_true;
         EXIT;
      END IF;
      i := g_tab_flex_col.NEXT(i);
   END LOOP;
--
   RETURN l_retval;
--
END is_column_allowable_for_flex;
--
----------------------------------------------------------------------------------------------
--
FUNCTION is_column_allowable_for_flex (p_column_id   user_tab_columns.column_id%TYPE)   RETURN VARCHAR2 IS
--
   l_retval VARCHAR2(5);
--
BEGIN
--
   IF g_tab_flex_col.EXISTS(p_column_id)
    THEN
      l_retval := Nm3type.c_true;
   ELSE
      l_retval := Nm3type.c_false;
   END IF;
--
   RETURN l_retval;
--
END is_column_allowable_for_flex;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_tab_ita (p_inv_type NM_INV_TYPES.nit_inv_type%TYPE) RETURN tab_nita IS
--
   CURSOR cs_ita (c_inv_type NM_INV_TYPES.nit_inv_type%TYPE) IS
   SELECT *
    FROM  NM_INV_TYPE_ATTRIBS
   WHERE  ita_inv_type = c_inv_type;
--
   l_tab_ita tab_nita;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'get_tab_ita');
--
   FOR cs_rec IN cs_ita (p_inv_type)
    LOOP
      l_tab_ita(l_tab_ita.COUNT+1) := cs_rec;
   END LOOP;
--
   Nm_Debug.proc_end(g_package_name,'get_tab_ita');
--
   RETURN l_tab_ita;
--
END get_tab_ita;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_tab_ita_exclusive (p_inv_type NM_INV_TYPES.nit_inv_type%TYPE) RETURN tab_nita IS
--
   l_tab_ita      tab_nita;
   l_tab_ita_excl tab_nita;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'get_tab_ita_exclusive');
--
   l_tab_ita := get_tab_ita (p_inv_type);
--
   FOR i IN 1..l_tab_ita.COUNT
    LOOP
      IF l_tab_ita(i).ita_exclusive = 'Y'
       THEN
         l_tab_ita_excl(l_tab_ita_excl.COUNT+1) := l_tab_ita(i);
      END IF;
   END LOOP;
--
   Nm_Debug.proc_end(g_package_name,'get_tab_ita_exclusive');
--
   RETURN l_tab_ita_excl;
--
END get_tab_ita_exclusive;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_tab_ita_displayed (p_inv_type NM_INV_TYPES.nit_inv_type%TYPE) RETURN tab_nita IS
--
   CURSOR cs_ita (c_inv_type NM_INV_TYPES.nit_inv_type%TYPE) IS
   SELECT *
    FROM  NM_INV_TYPE_ATTRIBS
   WHERE  ita_inv_type = c_inv_type
   AND    ita_displayed = 'Y'
   ORDER BY ita_disp_seq_no;

   l_tab_ita_disp tab_nita;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'get_tab_ita_displayed');
--

   OPEN cs_ita(p_inv_type);
   FETCH cs_ita BULK COLLECT INTO l_tab_ita_disp;
   CLOSE cs_ita;
/*
   FOR irec IN cs_ita(p_inv_type) LOOP
      IF irec.ita_displayed = 'Y'
       THEN
         l_tab_ita_disp(l_tab_ita_disp.COUNT+1) := irec;
      END IF;
   END LOOP;
*/
--
   Nm_Debug.proc_end(g_package_name,'get_tab_ita_displayed');
--
   RETURN l_tab_ita_disp;
--
END get_tab_ita_displayed;
--
----------------------------------------------------------------------------------------------
--
FUNCTION inv_type_is_hierarchical(pi_type           IN NM_INV_TYPES.nit_inv_type%TYPE
                                 ,pi_ignore_derived IN BOOLEAN DEFAULT TRUE
                                 ) RETURN BOOLEAN IS

  c_derived_relation CONSTANT NM_INV_TYPE_GROUPINGS.itg_relation%TYPE := 'DERIVED';

  l_nit_rec NM_INV_TYPES%ROWTYPE;

  l_relation NM_INV_TYPE_GROUPINGS.itg_relation%TYPE;

  l_child BOOLEAN;

  l_retval BOOLEAN;

BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'inv_type_is_hierarchical');

  l_nit_rec := get_inv_type(pi_inv_type => pi_type);

  DECLARE
    e_no_relation EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_no_relation, -20009);

  BEGIN
    l_relation := Nm3inv.get_itg(pi_inv_type => pi_type).itg_relation;

    l_child := TRUE;

  EXCEPTION
    WHEN e_no_relation
    THEN
      l_child := FALSE;

  END;

  l_retval := l_nit_rec.nit_top = 'Y'
              OR
              (l_child
               AND
               (NOT(pi_ignore_derived)
                OR
                (pi_ignore_derived
                 AND
                 l_relation <> c_derived_relation)));

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'inv_type_is_hierarchical');

  RETURN l_retval;

END inv_type_is_hierarchical;
--
----------------------------------------------------------------------------------------------
--
FUNCTION does_child_exist_diff_au_type (pi_inv_type IN NM_INV_TYPES.nit_inv_type%TYPE) RETURN BOOLEAN IS
--
   CURSOR cs_hier (c_start_inv_type NM_INV_TYPES.nit_inv_type%TYPE) IS
   SELECT itg_inv_type
         ,LEVEL
    FROM  NM_INV_TYPE_GROUPINGS
   CONNECT BY PRIOR itg_inv_type  = itg_parent_inv_type
   START WITH itg_parent_inv_type = c_start_inv_type;
--
   l_tab_inv_type Nm3type.tab_varchar4;
   l_tab_level    Nm3type.tab_number;
--
   l_top_au_type  NM_INV_TYPES.nit_admin_type%TYPE;
--
   l_retval       BOOLEAN := FALSE;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'does_child_exist_diff_au_type');
--
   l_top_au_type := Nm3ausec.get_inv_au_type (pi_inv_type);
--
   OPEN  cs_hier (pi_inv_type);
   FETCH cs_hier BULK COLLECT INTO l_tab_inv_type, l_tab_level;
   CLOSE cs_hier;
--
   FOR i IN 1..l_tab_inv_type.COUNT
    LOOP
      l_retval := (l_top_au_type != Nm3ausec.get_inv_au_type(l_tab_inv_type(i)));
      EXIT WHEN l_retval;
   END LOOP;
--
   Nm_Debug.proc_end(g_package_name,'does_child_exist_diff_au_type');
--
   RETURN l_retval;
--
END does_child_exist_diff_au_type;
--
----------------------------------------------------------------------------------------------
--
FUNCTION is_xsp_valid_on_inv_type (pi_inv_type IN NM_INV_TYPES.nit_inv_type%TYPE
                                  ,pi_xsp      IN NM_XSP.nwx_x_sect%TYPE
                                  ) RETURN BOOLEAN IS
--
--  THIS FUNCTION TAKES NO INTEREST INTO THE NETWORK TYPE OR SUB CLASS, IT IS INTERESTED
--   PURELY IF THE XSP AND INV TYPE COMBO EXISTS
--
   CURSOR cs_xsr (c_inv_type NM_INV_TYPES.nit_inv_type%TYPE
                 ,c_xsp      NM_XSP.nwx_x_sect%TYPE
                 ) IS
   SELECT 1
    FROM  XSP_RESTRAINTS
   WHERE  xsr_ity_inv_code = c_inv_type
    AND   xsr_x_sect_value = c_xsp;
--
   l_dummy  PLS_INTEGER;
   l_retval BOOLEAN;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'is_xsp_valid_on_inv_type');
--
   OPEN  cs_xsr (pi_inv_type, pi_xsp);
   FETCH cs_xsr INTO l_dummy;
   l_retval := cs_xsr%FOUND;
   CLOSE cs_xsr;
--
   Nm_Debug.proc_end(g_package_name,'is_xsp_valid_on_inv_type');
--
   RETURN l_retval;
--
END is_xsp_valid_on_inv_type;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE check_ita_id_domain(pi_ita_id_domain IN NM_INV_TYPE_ATTRIBS_ALL.ita_id_domain%TYPE
                             ,pi_ita_format     IN NM_INV_TYPE_ATTRIBS_ALL.ita_format%TYPE) IS

 l_rec_id NM_INV_DOMAINS_ALL%ROWTYPE;

BEGIN

 IF pi_ita_id_domain IS NOT NULL THEN

   l_rec_id := Nm3get.get_id_all (pi_id_domain => pi_ita_id_domain);

   IF  (l_rec_id.id_datatype  = Nm3type.c_varchar  AND pi_ita_format   != l_rec_id.id_datatype)
     OR (l_rec_id.id_datatype  = Nm3type.c_number   AND pi_ita_format   = Nm3type.c_date)
     OR (l_rec_id.id_datatype  = Nm3type.c_date     AND pi_ita_format   = Nm3type.c_number) THEN

         Hig.raise_ner (pi_appl               => Nm3type.c_net
                       ,pi_id                 => 309
                       ,pi_supplementary_info => l_rec_id.id_datatype||':'||pi_ita_format
                       );
   END IF;

 END IF;

END check_ita_id_domain;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE check_ita_query(pi_ita_query       IN NM_INV_TYPE_ATTRIBS_ALL.ita_query%TYPE
                         ,pi_ita_inv_type    IN NM_INV_TYPE_ATTRIBS_ALL.ita_inv_type%TYPE
                         ,pi_ita_attrib_name IN NM_INV_TYPE_ATTRIBS_ALL.ita_attrib_name%TYPE) IS

BEGIN

 IF pi_ita_query IS NOT NULL THEN


  --
  -- ita_query can only be specified for AD data cos it's only been coded to work
  -- in the AD flexible blocks on forms
  -- If it's required in other places then there's a major code impact i.e. on nm3gaz_qry and
  -- forms such as assets on a route.
  --
  -- TASK 0109336 
  -- Allow setting of ITA_QUERY for all Categories
  --IF Nm3get.get_nit(pi_nit_inv_type => pi_ita_inv_type).nit_category != 'G' THEN
  --             Hig.raise_ner(pi_appl => 'NET'
  --                          ,pi_id   => 422);
  --END IF;

  Nm3flx.validate_ita_query(pi_query           => pi_ita_query
                           ,pi_ita_inv_type    => pi_ita_inv_type
                           ,pi_ita_attrib_name => pi_ita_attrib_name);

 END IF;

END check_ita_query;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE check_ita_domain_query_excl(pi_ita_id_domain   IN NM_INV_TYPE_ATTRIBS_ALL.ita_id_domain%TYPE
                                     ,pi_ita_query       IN NM_INV_TYPE_ATTRIBS_ALL.ita_query%TYPE) IS
BEGIN

 IF pi_ita_id_domain IS NOT NULL AND pi_ita_query IS NOT NULL THEN

         Hig.raise_ner (pi_appl               => Nm3type.c_net
                       ,pi_id                 => 396  -- Specify either a domain or a query - not both
                       );

 END IF;

END check_ita_domain_query_excl;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE  check_disp_width
  ( pi_ita_disp_width IN NUMBER
  , pi_ita_displayed  IN VARCHAR2
  , pi_ita_fld_length IN NUMBER
  ) IS
BEGIN

  IF NVL(pi_ita_displayed,'N') = 'Y'
  THEN
    IF  NVL(pi_ita_disp_width,0) = 0
    THEN
      Hig.raise_ner
        (pi_appl               => Nm3type.c_net
        ,pi_id                 => 50
        ,pi_supplementary_info => 'Displayed width not set when Displayed is switched on'
        );
    END IF ;
  END IF;
END check_disp_width;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE check_ita_view_col_name ( pi_ita_view_col_name IN nm_inv_type_attribs_all.ita_view_col_name%TYPE) IS
BEGIN
  --nm_debug.debug_on ;
  --nm_debug.debug('pi_ita_view_col_name ' || pi_ita_view_col_name);
  --nm_debug.debug_off ;

  IF nm3flx.string_contains_special_chars(pi_string => pi_ita_view_col_name)
  THEN
      hig.raise_ner( pi_appl               => 'NET'
                   , pi_id                 => 30
                   , pi_supplementary_info => pi_ita_view_col_name);
                    -- Value is invalid. Please use only alphanumeric characters with no spaces. 
                   --The underscore character "_" can be used for spaces.
   END IF;
--
-- AE 04-FEB-2009
-- Check to make sure the view column name isnt a reserved word
--
  IF nm3flx.is_reserved_word(p_name => pi_ita_view_col_name)
  THEN
    hig.raise_ner(pi_appl               => 'NET'
                , pi_id                 => 455
                , pi_supplementary_info => pi_ita_view_col_name);
                -- The name you have chosen is a reserved word in Oracle - please choose a non-reserved word
  END IF;
--
END check_ita_view_col_name;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE check_ngqs ( pi_ita_inv IN nm3inv.g_tab_ita%TYPE )
IS
-- Remove any NM_GAZ_QUERY_ATTRIBS_SAVED records which are now invalid
-- as a result of changes to the NM_INV_TYPE_ATTRIBS
BEGIN
--
  FOR i IN 1..pi_ita_inv.COUNT LOOP
  --
    DELETE nm_gaz_query_attribs_saved
     WHERE ngqas_nit_type = pi_ita_inv(i).ita_inv_type
       AND NOT EXISTS
       ( SELECT 1 FROM nm_inv_type_attribs
          WHERE ita_inv_type = ngqas_nit_type
            AND ngqas_attrib_name = ita_attrib_name );
  --
  END LOOP;
END check_ngqs;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE process_g_tab_ita 
IS
BEGIN
--
  IF g_tab_ita.COUNT > 0
  THEN
--
    FOR i IN 1..g_tab_ita.COUNT LOOP
    --
    -- Check Domain
      check_ita_id_domain
         ( pi_ita_id_domain => g_tab_ita(i).ita_id_domain
         , pi_ita_format    => g_tab_ita(i).ita_format);
    --
      check_ita_query
         ( pi_ita_query       => g_tab_ita(i).ita_query
         , pi_ita_inv_type    => g_tab_ita(i).ita_inv_type
         , pi_ita_attrib_name => g_tab_ita(i).ita_attrib_name);
    --
      check_ita_domain_query_excl
         ( pi_ita_id_domain  => g_tab_ita(i).ita_id_domain
         , pi_ita_query      => g_tab_ita(i).ita_query);
    --
      check_disp_width
         ( pi_ita_disp_width => g_tab_ita(i).ita_disp_width
         , pi_ita_displayed  => g_tab_ita(i).ita_displayed
         , pi_ita_fld_length => g_tab_ita(i).ita_fld_length) ;
    --
      check_ita_view_col_name ( pi_ita_view_col_name => g_tab_ita(i).ita_view_col_name );
    --
    END LOOP;
  --
  -- Remove any NM_GAZ_QUERY_ATTRIBS_SAVED records which are now invalid
  -- as a result of changes to the NM_INV_TYPE_ATTRIBS 
  -- This cannot be done by cascading keys due to Locator using attribs which
  -- are fixed and not part of the inventory metamodel
    check_ngqs
      ( pi_ita_inv => g_tab_ita );
  --
  END IF;
--
END process_g_tab_ita;
--
----------------------------------------------------------------------------------------------
--
--<PROC NAME=""CREATE_FT_ASSET_FROM_TABLE">
-- Create a Foreign Table Asset type from a table
  PROCEDURE create_ft_asset_from_table
               ( pi_table_name         IN     user_tables.table_name%TYPE
               , pi_pk_column          IN     user_tab_columns.column_name%TYPE
               , pi_asset_type         IN     NM_INV_TYPES.nit_inv_type%TYPE
               , pi_asset_descr        IN     NM_INV_TYPES.nit_descr%TYPE
               , pi_start_date         IN     DATE                                     DEFAULT '01-JAN-1900'
               , pi_pnt_or_cont        IN     NM_INV_TYPES.nit_pnt_or_cont%TYPE        DEFAULT 'P'
               , pi_use_xy             IN     NM_INV_TYPES.nit_use_xy%TYPE             DEFAULT 'N'
               , pi_x_column           IN     user_tab_columns.column_name%TYPE
               , pi_y_column           IN     user_tab_columns.column_name%TYPE
               , pi_lr_ne_column       IN     NM_INV_TYPES.nit_lr_ne_column_name%TYPE  DEFAULT NULL
               , pi_lr_st_chain        IN     NM_INV_TYPES.nit_lr_st_chain%TYPE        DEFAULT NULL
               , pi_lr_end_chain       IN     NM_INV_TYPES.nit_lr_end_chain%TYPE       DEFAULT NULL
               , pi_attrib_ltrim       IN     NUMBER                                   DEFAULT 5
               , pi_admin_type         IN     NM_INV_TYPES.nit_admin_type%TYPE         DEFAULT Nm3get.get_nau( pi_nau_admin_unit => Nm3get.get_hus(pi_hus_username=>USER).hus_admin_unit).nau_admin_type
               , pi_role               IN     NM_INV_TYPE_ROLES.itr_hro_role%TYPE      DEFAULT 'HIG_USER'
               , pi_role_mode          IN     NM_INV_TYPE_ROLES.itr_mode%TYPE          DEFAULT 'NORMAL'
               )
  IS
  --
    TYPE
      tab_utc IS TABLE OF user_tab_columns%ROWTYPE
                 INDEX BY BINARY_INTEGER;
  -- nm_inv_types_all
    l_tab_utc                 tab_utc;
    l_rec_nit                 NM_INV_TYPES%ROWTYPE;
    l_rec_ntc                 NM_INV_TYPE_ATTRIBS%ROWTYPE;
    l_rec_itr                 NM_INV_TYPE_ROLES%ROWTYPE;
  --
    e_table_doesnt_exist      EXCEPTION;
    e_nit_type_too_long       EXCEPTION;
    e_invalid_p_or_c          EXCEPTION;
    e_pk_col_not_found        EXCEPTION;
    e_lr_ne_col_not_found     EXCEPTION;
    e_lr_st_chain_not_found   EXCEPTION;
    e_lr_end_chain_not_found  EXCEPTION;
  --
    FUNCTION does_column_exist
               ( pi_column_name IN user_tab_columns.column_name%TYPE )
    RETURN BOOLEAN
    IS
      l_dummy NUMBER;
    BEGIN
      SELECT 1 INTO l_dummy
        FROM user_tab_columns
       WHERE table_name = pi_table_name
         AND column_name = pi_column_name;
      RETURN TRUE;
    EXCEPTION
      WHEN NO_DATA_FOUND
      THEN RETURN FALSE;
    END does_column_exist;
  --
  BEGIN
  --
    BEGIN
    -- Check to make sure table exists
      SELECT * BULK COLLECT INTO l_tab_utc
        FROM user_tab_columns
       WHERE table_name = pi_table_name
         AND DATA_TYPE != 'SDO_GEOMETRY';
      DBMS_OUTPUT.PUT_LINE('Table = '||l_Tab_utc(1).table_name);
     EXCEPTION
       WHEN NO_DATA_FOUND
       THEN
         RAISE e_table_doesnt_exist;
     END;
   --
   -- Check to make sure PK column specified exists
   --
     IF NOT does_column_exist (pi_pk_column)
     THEN
       RAISE e_pk_col_not_found;
     END IF;
   --
   -- Check for lr columns if specified
   --
     IF pi_lr_ne_column IS NOT NULL THEN
       IF NOT does_column_exist (pi_lr_ne_column) THEN
         RAISE e_lr_ne_col_not_found;
       END IF;
     END IF;
   --
     IF pi_lr_st_chain IS NOT NULL THEN
       IF NOT does_column_exist (pi_lr_st_chain) THEN
         RAISE e_lr_st_chain_not_found;
       END IF;
     END IF;
   --
     IF pi_lr_end_chain IS NOT NULL THEN
       IF NOT does_column_exist (pi_lr_end_chain) THEN
         RAISE e_lr_end_chain_not_found;
       END IF;
     END IF;
   --
   -- Check to make sure Asset type isnt too long
   --
     IF LENGTH(pi_asset_type) > 4
     THEN
       RAISE e_nit_type_too_long;
     END IF;
   --
   -- Check to make sure pi_pnt_or_cont is valid
   --
     IF pi_pnt_or_cont NOT IN ('P','C')
     THEN
       RAISE e_invalid_p_or_c;
     END IF;
   --
   -- Create the Asset type
   --
     --Nm_Debug.debug_on;
     Nm_Debug.DEBUG('Admin type = '||pi_admin_type);
     l_rec_nit.nit_inv_type          := pi_asset_type;
     l_rec_nit.nit_pnt_or_cont       := pi_pnt_or_cont;
     l_rec_nit.nit_x_sect_allow_flag := 'N';
     l_rec_nit.nit_elec_drain_carr   := 'C';
     l_rec_nit.nit_contiguous        := 'N';
     l_rec_nit.nit_replaceable       := 'Y';
     l_rec_nit.nit_exclusive         := 'N';
     l_rec_nit.nit_category          := 'F';
     -- CWS TEST 0108036 description parameter was being ignored. Description is now added if it is not null
     l_rec_nit.nit_descr             := nvl(pi_asset_descr, pi_table_name||' - Foreign Table asset type');
     l_rec_nit.nit_linear            := 'N';
     l_rec_nit.nit_use_xy            := pi_use_xy;
     l_rec_nit.nit_multiple_allowed  := 'Y';
     l_rec_nit.nit_end_loc_only      := 'N';
     l_rec_nit.nit_screen_seq        := 10;
     l_rec_nit.nit_view_name         := NULL;
     l_rec_nit.nit_start_date        := pi_start_date;
     l_rec_nit.nit_short_descr       := pi_table_name;
     l_rec_nit.nit_flex_item_flag    := 'N';
     l_rec_nit.nit_table_name        := pi_table_name;
     l_rec_nit.nit_lr_ne_column_name := pi_lr_ne_column;
     l_rec_nit.nit_lr_st_chain       := pi_lr_st_chain;
     l_rec_nit.nit_lr_end_chain      := pi_lr_end_chain;
     l_rec_nit.nit_admin_type        := pi_admin_type;
     l_rec_nit.nit_icon_name         := NULL;
     l_rec_nit.nit_top               := 'N';
     l_rec_nit.nit_foreign_pk_column := pi_pk_column;
     l_rec_nit.nit_update_allowed    := 'Y';
     l_rec_nit.nit_notes             := pi_table_name||' - Foreign Table asset type';
   --
     Nm3ins.ins_nit ( p_rec_nit => l_rec_nit );

   --
   -- Create nm_inv_type_attribs
   --
     FOR i IN 1..l_tab_utc.COUNT
     LOOP --nm_inv_type_attribs
    -- user_tab_columns
       l_rec_ntc.ita_inv_type         := pi_asset_type;
       l_rec_ntc.ita_attrib_name      := l_tab_utc(i).column_name;
       l_rec_ntc.ita_dynamic_attrib   := 'N';
       l_rec_ntc.ita_disp_seq_no      := i;
       l_rec_ntc.ita_mandatory_yn     := 'N';
       l_rec_ntc.ita_fld_length       := NVL(l_tab_utc(i).data_precision,l_tab_utc(i).data_length);
       l_rec_ntc.ita_dec_places       := l_tab_utc(i).data_scale;
       l_rec_ntc.ita_scrn_text        := INITCAP(REPLACE(SUBSTR(l_tab_utc(i).column_name,pi_attrib_ltrim,LENGTH(l_tab_utc(i).column_name)),'_',' '));
       l_rec_ntc.ita_view_attri       := l_tab_utc(i).column_name;
       l_rec_ntc.ita_view_col_name    := l_tab_utc(i).column_name;
       l_rec_ntc.ita_start_date       := pi_start_date;
       l_rec_ntc.ita_queryable        := 'Y';
       l_rec_ntc.ita_validate_yn      := 'N';
       l_rec_ntc.ita_format           := l_tab_utc(i).data_type;
       l_rec_ntc.ita_exclusive        := 'N';
       l_rec_ntc.ita_keep_history_yn  := 'N';
       l_rec_ntc.ita_displayed        := 'Y';
    --
       IF l_tab_utc(i).data_type = nm3type.c_number
       THEN
         l_rec_ntc.ita_disp_width       := 8;
       ELSIF l_tab_utc(i).data_type = nm3type.c_varchar
       THEN
         l_rec_ntc.ita_disp_width       := 20;
       ELSIF l_tab_utc(i).data_type = nm3type.c_date
       THEN
         l_rec_ntc.ita_disp_width       := 11;
       ELSE
         l_rec_ntc.ita_disp_width       := 15;
       END IF;
    --
       Nm3ins.ins_ita( p_rec_ita => l_rec_ntc );
    --
    END LOOP;

  --
  -- Create Roles
  --
    l_rec_itr.itr_inv_type := pi_asset_type;
    l_rec_itr.itr_hro_role := pi_role;
    l_rec_itr.itr_mode     := pi_role_mode;
    Nm3ins.ins_itr ( p_rec_itr => l_rec_itr );

  --
  --
  --
  EXCEPTION
    WHEN e_table_doesnt_exist
    THEN
      RAISE_APPLICATION_ERROR(-20101,'Error - '||pi_table_name||' does not exist');
    WHEN e_nit_type_too_long
    THEN
      RAISE_APPLICATION_ERROR(-20102,'Error - Asset type must be no longer than 4 characters - ['
                            ||pi_asset_type||']');
    WHEN e_invalid_p_or_c
    THEN
      RAISE_APPLICATION_ERROR(-20103,'Error - Point or Cont must be P or C - not '||pi_pnt_or_cont);
    WHEN e_pk_col_not_found
    THEN
      RAISE_APPLICATION_ERROR(-20104,'Error - '||pi_pk_column||' does not exist on table '||pi_table_name);
    WHEN e_lr_ne_col_not_found
    THEN
      RAISE_APPLICATION_ERROR(-20105,'Error - '||pi_lr_ne_column||' does not exist on table '||pi_table_name);
    WHEN e_lr_st_chain_not_found
    THEN
      RAISE_APPLICATION_ERROR(-20106,'Error - '||pi_lr_st_chain||' does not exist on table '||pi_table_name);
    WHEN e_lr_end_chain_not_found
    THEN
      RAISE_APPLICATION_ERROR(-20107,'Error - '||pi_lr_end_chain||' does not exist on table '||pi_table_name);
    WHEN OTHERS
    THEN
      RAISE;
  END create_ft_asset_from_table;
--
-----------------------------------------------------------------------------
--
FUNCTION is_linear_asset_type(pi_nit_inv_type IN nm_inv_types_all.nit_inv_type%TYPE) RETURN BOOLEAN IS

BEGIN
 RETURN(get_inv_type(pi_inv_type => pi_nit_inv_type).nit_linear = 'Y');
END is_linear_asset_type;
--
-----------------------------------------------------------------------------
--
FUNCTION is_cont_asset_type(pi_nit_inv_type IN nm_inv_types_all.nit_inv_type%TYPE) RETURN BOOLEAN IS

BEGIN
 RETURN(get_inv_type(pi_inv_type => pi_nit_inv_type).nit_pnt_or_cont = 'C');
END is_cont_asset_type;
--
-----------------------------------------------------------------------------
--
-- this procedure was introduced to be called from nm3nwval.check_members
-- which itself is called from ins_nm_members trigger on NM_MEMBERS_ALL
--
-- Note: other location checking is done in on the client forms e.g. NM0510 and NM0590
-- in program units LOCATE_INVENTORY and GET_NETWORK_LOCATION
--
PROCEDURE check_asset_location(pi_nit_inv_type IN nm_inv_types_all.nit_inv_type%TYPE
                              ,pi_begin_mp     IN nm_members_all.nm_begin_mp%TYPE
                              ,pi_end_mp       IN nm_members_all.nm_end_mp%TYPE) IS

BEGIN

 IF is_cont_asset_type(pi_nit_inv_type => pi_nit_inv_type) THEN

    IF pi_begin_mp = pi_end_mp THEN
      hig.raise_ner(pi_appl => 'NET'
	               ,pi_id   => 86);  -- Continuous asset cannot have start and end points that are the same.

    END IF;

    IF pi_begin_mp > pi_end_mp THEN
      hig.raise_ner(pi_appl => 'NET'
	               ,pi_id   => 80);  -- Continuous asset cannot have start and end points that are the same.

    END IF;

 END IF;

END check_asset_location;
--
-----------------------------------------------------------------------------
--
-- MJA add 31-Aug-07
-- Speaks for itself.  If true then bypass triggers.
-- To be called in NM_INV_ITEMS_ALL_SDO_B_UPD, NM_INV_ITEMS_ALL_SDO_B_STM,
--  NM_INV_ITEMS_ALL_SDO_A_STM, NM_INV_ITEMS_ALL_ROLE_SEC, NM_INV_ITEMS_ALL_EXCL_A_STM,
--  NM_INV_ITEMS_ALL_EXCL_B_ROW, NM_INV_ITEMS_ALL_EXCL_B_STM triggers to see if 
--  bypass required
--
FUNCTION bypass_inv_items_all_trgs 
  RETURN BOOLEAN
IS
  --
Begin
  --
  Return nvl(g_bypass_inv_items_all_trgs, FALSE);
  --
End bypass_inv_items_all_trgs;
--
----------------------------------------------------------------------------------
--
-- MJA add 31-Aug-07
-- Sets global g_bypass_inv_items_all_trgs true or false.
--
PROCEDURE bypass_inv_items_all_trgs ( pi_mode IN BOOLEAN )
IS
  --
Begin
  --
  g_bypass_inv_items_all_trgs := pi_mode;
  --
End bypass_inv_items_all_trgs;
--
----------------------------------------------------------------------------------
--
-- Return the case of an attribute from ita_case
  FUNCTION get_ita_case ( pi_asset_type   IN  nm_inv_type_attribs.ita_inv_type%TYPE
                        , pi_attrib_name  IN  nm_inv_type_attribs.ita_attrib_name%TYPE ) 
    RETURN nm_inv_type_attribs.ita_case%TYPE
  IS
    CURSOR get_case
             ( cp_asset_type   IN  nm_inv_type_attribs.ita_inv_type%TYPE
             , cp_attrib_name  IN  nm_inv_type_attribs.ita_attrib_name%TYPE )
    IS
      SELECT DECODE (ita_case,'MIXED',NULL,ita_case) FROM nm_inv_type_attribs
       WHERE ita_inv_type = cp_asset_type
         AND ita_attrib_name = cp_attrib_name;
  --
    retval  nm_inv_type_attribs.ita_case%TYPE;
  BEGIN
  --
    OPEN  get_case ( pi_asset_type, pi_attrib_name );
    FETCH get_case INTO retval;
    CLOSE get_case;
  --
    RETURN retval;
  --
  END get_ita_case;
--
----------------------------------------------------------------------------------
--
-- Return the varchar2 value after upper/lowering it depending on ita_case
  FUNCTION format_with_ita_case ( pi_asset_type   IN  nm_inv_type_attribs.ita_inv_type%TYPE
                                , pi_attrib_name  IN  nm_inv_type_attribs.ita_attrib_name%TYPE
                                , pi_value        IN  VARCHAR2 ) 
    RETURN VARCHAR2
  IS
    retval                 nm3type.max_varchar2;
    l_quote                VARCHAR2(10) := chr(39);
    l_dummy                VARCHAR2(10) := chr(126)||chr(33)||chr(36)||chr(33)||chr(126);  
    l_sql                  nm3type.max_varchar2;
    l_asset_type           nm_inv_type_attribs%ROWTYPE;
    b_ignore_domains       BOOLEAN      := NVL(hig.get_sysopt('IGNDOMCASE'),'N') = 'Y';
  --
  BEGIN
  -- Task 0109768 and 0109764
  -- Ensure formmating of Case works with single quotes (chr(39))
    IF pi_asset_type   IS NOT NULL
    AND pi_attrib_name IS NOT NULL
    AND pi_value       IS NOT NULL
    THEN
      l_asset_type := nm3get.get_ita
                        ( pi_ita_inv_type    => pi_asset_type
                        , pi_ita_attrib_name => pi_attrib_name
                        , pi_raise_not_found => FALSE );
    --
      IF l_asset_type.ita_inv_type IS NOT NULL
    --
    -- Task 0110838
    -- Reintroduce case based domain attributes
      AND ( l_asset_type.ita_id_domain IS NULL 
          OR ( NOT (b_ignore_domains) AND  l_asset_type.ita_id_domain IS NOT NULL )
          )
    --
      AND l_asset_type.ita_case != 'MIXED'
      THEN
        l_sql := ' SELECT REPLACE('||get_ita_case (pi_asset_type, pi_attrib_name)
                           ||'(REPLACE (:l_value,:l_quote,:l_dummy)),:l_dummy,:l_quote)'||
                   ' FROM DUAL';
    --
        EXECUTE IMMEDIATE l_sql INTO retval
        USING IN pi_value, IN l_quote, IN l_dummy, IN l_dummy, IN l_quote;
      ELSE 
        retval := pi_value;
      END IF;
    --
    END IF;
  --
    RETURN retval;
  --
  END format_with_ita_case;
--
----------------------------------------------------------------------------------
--
--
--  MAIN
BEGIN  /* inv - automatic variables */
  /* instantiate common error messages */
  g_thing_already_exists := Hig.get_error_message( 'HWAYS' ,122);
  g_thing_does_not_exist := Hig.get_error_message( 'HWAYS' ,121);
  instantiate_flex_cols;
END Nm3inv;
/
