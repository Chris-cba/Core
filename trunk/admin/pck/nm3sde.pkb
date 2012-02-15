CREATE OR REPLACE PACKAGE BODY Nm3sde AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3sde.pkb-arc   2.18   Feb 15 2012 10:21:40   Rob.Coupe  $
--       Module Name      : $Workfile:   nm3sde.pkb  $
--       Date into PVCS   : $Date:   Feb 15 2012 10:21:40  $
--       Date fetched Out : $Modtime:   Feb 15 2012 10:15:38  $
--       PVCS Version     : $Revision:   2.18  $
--
--       Based on one of many versions labeled as 1.21
--
--   Author : R.A. Coupe
--
--   Spatial Data Manager specific package body
--
-----------------------------------------------------------------------------
-- Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  VARCHAR2(2000) := '"$Revision:   2.18  $"';
   g_keyword         CONSTANT  VARCHAR2(30)   := 'SDO_GEOMETRY'; --get_keyword;


FUNCTION  get_next_sde_layer RETURN NUMBER;
FUNCTION  get_next_sde_table_id RETURN NUMBER;
FUNCTION  get_next_srid RETURN NUMBER;
PROCEDURE pop_sde_obj_from_theme( p_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE,
                                  p_parent_id IN NM_THEMES_ALL.nth_theme_id%TYPE,
                                  p_layer  OUT layer_record_t,
                                  p_geocol OUT geocol_record_t,
                                  p_reg    OUT registration_record_t );
FUNCTION get_geocol( p_table IN VARCHAR2, p_column IN VARCHAR2 )  RETURN geocol_record_t;

PROCEDURE copy_sde_obj_from_theme( p_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE,
                                   p_theme_usr IN HIG_USER_ROLES.HUR_USERNAME%TYPE
                                 );
FUNCTION get_SDE_pk ( p_nth IN NM_THEMES_ALL%ROWTYPE ) RETURN VARCHAR2;


-- AE 19 June 2008
-- delete column registry
PROCEDURE del_creg( p_table IN VARCHAR2, p_owner IN VARCHAR2);


-----------------------------------------------------------------------------
--
-- Function to return the srtext for a theme
--

function get_srtext ( p_theme_id in NM_THEMES_ALL.nth_theme_id%TYPE, p_base in nm_theme_array  ) return varchar2;

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
FUNCTION get_sde_version RETURN VARCHAR2 IS
retval VARCHAR2(255);
BEGIN
--  SELECT prop_value
--  INTO retval
--  FROM sde.metadata
--  WHERE record_id = 1;
--

-- AE  19-FEB-2009
-- Use SDE.VERSION table instead
--
  SELECT major||'.'||minor
    INTO retval
    FROM sde.version
   WHERE rownum=1 ; -- just incase anyone has been hacking about
--
  IF SQL%NOTFOUND THEN
    RAISE_APPLICATION_ERROR( -20001, 'Version not found');
  END IF;
--
  RETURN retval;
END;
--
------------------------------------------------------------------------------------------------------------------
--

--
------------------------------------------------------------------------------------------------------------------
--

PROCEDURE register_sde_layer( p_theme_id IN NM_THEMES_ALL.NTH_THEME_ID%TYPE) IS

--
--procedure expects that the theme has already been registered in NM_THEMES etc
--

l_geom   VARCHAR2(30);

l_theme  NM_THEMES_ALL%ROWTYPE;

l_layer  layer_record_t;
l_geocol geocol_record_t;
l_reg    registration_record_t;

BEGIN

  l_theme := Nm3sdm.get_nth( p_theme_id );

  pop_sde_obj_from_theme( p_theme_id => p_theme_id,
                          p_parent_id => l_theme.nth_base_table_theme,
                          p_layer  => l_layer,
                          p_geocol => l_geocol,
                          p_reg    => l_reg);

END;

--
----------------------------------------------------------------------------------------------------------------------------
--

FUNCTION  get_next_sde_layer RETURN NUMBER IS
retval NUMBER;
BEGIN
  SELECT sde.LAYER_ID_GENERATOR.NEXTVAL INTO retval FROM dual;
  RETURN retval;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                    ,pi_id                 => 190
                    ,pi_sqlcode            => -20001
                    );

--    raise_application_error(-20001, 'Layer generator failure');
END;

--
----------------------------------------------------------------------------------------------------------------------
--

FUNCTION  get_next_sde_table_id RETURN NUMBER IS
retval NUMBER;
BEGIN
  SELECT sde.TABLE_ID_GENERATOR.NEXTVAL INTO retval FROM dual;
  RETURN retval;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                    ,pi_id                 => 191
                    ,pi_sqlcode            => -20001
                    );

--    raise_application_error(-20001, 'Table registration id generator failure');

END;

--
----------------------------------------------------------------------------------------------------------------------
--

FUNCTION  get_next_srid RETURN NUMBER IS
retval NUMBER;
BEGIN
  SELECT sde.LOCATOR_ID_GENERATOR.NEXTVAL INTO retval FROM dual;
  RETURN retval;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
     Hig.raise_ner(pi_appl                => Nm3type.c_hig
                  ,pi_id                 => 251
                  ,pi_sqlcode            => -20001
                   );
--   raise_application_error(-20001, 'SRID generator failure');
END;


--
------------------------------------------------------------------------------------------------------------
--

PROCEDURE pop_sde_obj_from_theme( p_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE,
                                  p_parent_id IN NM_THEMES_ALL.nth_theme_id%TYPE,
                                  p_layer  OUT layer_record_t,
                                  p_geocol OUT geocol_record_t,
                                  p_reg    OUT registration_record_t ) IS

l_theme      NM_THEMES_ALL%ROWTYPE;
l_parent     NM_THEMES_ALL%ROWTYPE;
l_base_layer layer_record_t;   --sde.layers.base_layer_id%type;

l_usgm    user_sdo_geom_metadata%ROWTYPE := Nm3sdo.get_theme_metadata( p_theme_id );
l_diminfo mdsys.sdo_dim_array := l_usgm.diminfo;
l_gtype   NUMBER;
l_geotype NUMBER;

l_base_layer_id NUMBER := 0;
l_srid          NUMBER;

l_date NUMBER := get_date_for_sde;

l_base nm_theme_array;

l_type NUMBER;

BEGIN

  l_theme := Nm3get.get_nth( p_theme_id );

  IF p_parent_id IS NOT NULL THEN

--  Here we have a view based on an existing table. Use the existing registration data as this is
--  assumed to be more reliable.

    l_parent := Nm3get.get_nth( p_parent_id);

    BEGIN
      p_layer  := get_sde_layer_from_theme(p_theme_id => p_parent_id );
      p_geocol := get_geocol( l_parent.nth_feature_table, l_parent.nth_feature_shape_column );
      p_reg    := get_treg( l_parent.nth_feature_table );
      p_layer.BASE_LAYER_ID     := p_layer.layer_id;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
       p_layer := generate_sde_layer_from_theme( l_theme );

    WHEN OTHERS THEN
      p_layer := generate_sde_layer_from_theme( l_theme );
    END;

    p_layer.LAYER_ID          := get_next_sde_layer;
    p_layer.DESCRIPTION       := l_theme.nth_theme_name;
    p_layer.OWNER             := Sys_Context('NM3CORE','APPLICATION_OWNER');
    p_layer.TABLE_NAME        := l_theme.nth_feature_table;
    p_layer.SPATIAL_COLUMN    := l_theme.nth_feature_shape_column;
    p_layer.CDATE             := l_date;

--  p_reg.ROWID_COLUMN        := l_theme.nth_feature_pk_column;
--  RAC - FK issue still unresolved.

  ELSE
    p_layer := generate_sde_layer_from_theme( l_theme );

  END IF;

  l_gtype  := Nm3sdo.get_theme_gtype( p_theme_id );
  l_type   := get_sde_type_from_gtype( l_gtype );


  p_geocol.F_TABLE_CATALOG  := NULL;
  p_geocol.F_TABLE_SCHEMA   := Sys_Context('NM3CORE','APPLICATION_OWNER');
  p_geocol.F_TABLE_NAME     := l_theme.nth_feature_table;
  p_geocol.F_GEOMETRY_COLUMN:= l_theme.nth_feature_shape_column;
  p_geocol.G_TABLE_CATALOG  := NULL;
  p_geocol.G_TABLE_SCHEMA   := Sys_Context('NM3CORE','APPLICATION_OWNER');
  p_geocol.G_TABLE_NAME     := l_theme.nth_feature_table;
  p_geocol.STORAGE_TYPE     := 2;
  p_geocol.GEOMETRY_TYPE    := l_type;
  p_geocol.COORD_DIMENSION  := NULL;
  p_geocol.MAX_PPR          := NULL;
  p_geocol.SRID             := p_layer.srid;


  p_reg.REGISTRATION_ID     := get_next_sde_table_id;
  p_reg.TABLE_NAME          := l_theme.nth_feature_table;
  p_reg.OWNER               := Sys_Context('NM3CORE','APPLICATION_OWNER');

  p_reg.ROWID_COLUMN        := get_SDE_pk ( p_nth => l_theme );

  p_reg.DESCRIPTION         := l_theme.nth_theme_name;
  p_reg.OBJECT_FLAGS        := 5; -- or 132 for points
  p_reg.REGISTRATION_DATE   := l_date;
  p_reg.CONFIG_KEYWORD      := 'SDO_GEOMETRY';
  p_reg.MINIMUM_ID          := 1;
  p_reg.IMV_VIEW_NAME       := NULL;

  IF INSTR( p_layer.table_name, '@') = 0 THEN

--  need to do this so that the sde procedure, executed as SDE will work OK.
--  It will not work across a DB link, but may work on a view which uses a DB link.
--  If it is a DB link then it is assumed SDE can see the table anyway, preferably with a public
--  DB link (and appropriate privileges)

    DECLARE
      l_str   VARCHAR2(2000);
    BEGIN
      l_str := 'grant all on '||p_layer.table_name||' to SDE';
      EXECUTE IMMEDIATE l_str;
    END;

  END IF;

  DECLARE
    no_access EXCEPTION;
    PRAGMA EXCEPTION_INIT ( no_access, -20037 );
  BEGIN

    sde.sdo_util.register_layer( p_layer, p_geocol, p_reg );

  EXCEPTION
    WHEN no_access THEN
      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                   ,pi_id                 => 252
                   ,pi_sqlcode            => -20001
                   );
--    raise_application_error (-20001, 'Table is not registered or SDE schema cannot see it');
  END;

  create_column_registry( p_layer.table_name, p_geocol.f_geometry_column, p_reg.rowid_column );

END;

--
---------------------------------------------------------------------------------------------------------------
--

FUNCTION get_sde_layer_from_theme ( p_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE ) RETURN sde.layers%ROWTYPE IS

CURSOR c1( c_tab IN VARCHAR2, c_col IN VARCHAR2 ) IS
  SELECT *
  FROM sde.layers
  WHERE table_name = c_tab
  AND   spatial_column = c_col
  AND   owner = Sys_Context('NM3CORE','APPLICATION_OWNER');

retval sde.layers%ROWTYPE;

l_nth NM_THEMES_ALL%ROWTYPE := Nm3get.get_nth( p_theme_id );

BEGIN
  OPEN c1( l_nth.nth_feature_table, l_nth.nth_feature_shape_column );

  FETCH c1 INTO retval;

  IF c1%NOTFOUND THEN
    CLOSE c1;
     Hig.raise_ner(pi_appl                => Nm3type.c_hig
                  ,pi_id                 => 253
                  ,pi_sqlcode            => -20001
                   );
--  raise_application_error( -20001, 'No sde layer for theme');
  END IF;

  RETURN retval;
END;

--
---------------------------------------------------------------------------------------------------------------
--

FUNCTION get_sde_layer_id_from_theme ( p_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE,
                                       null_exc VARCHAR2 DEFAULT 'FALSE') RETURN sde.layers.layer_id%TYPE IS

l_layer layer_record_t;

BEGIN
  l_layer := get_sde_layer_from_theme( p_theme_id );
  RETURN l_layer.layer_id;
EXCEPTION
  WHEN OTHERS THEN
    IF null_exc = 'TRUE'  THEN
   RETURN 0;
 ELSE
   RAISE;
 END IF;
END;

--
---------------------------------------------------------------------------------------------------------------
--

FUNCTION generate_sde_layer_from_theme ( p_nth IN nm_themes_all%ROWTYPE ) RETURN sde.layers%ROWTYPE IS

retval sde.layers%ROWTYPE;

l_diminfo  mdsys.sdo_dim_array;
l_srid     NUMBER;
l_usgm     user_sdo_geom_metadata%ROWTYPE;
l_base     nm_theme_array := nm_theme_array( nm_theme_array_type( nm_theme_entry(NULL)));
l_base_lyr sde.layers%ROWTYPE;

BEGIN

    l_base  := Nm3sdm.get_base_themes( p_nth.nth_theme_id );

    IF l_base.nta_theme_array.LAST IS NOT NULL AND l_base.nta_theme_array(1) IS NOT NULL THEN

      Nm3sdo.set_diminfo_and_srid( l_base, l_diminfo, l_srid ); -- this guarantees that consistent base srids are in use from the Oracle perspective

    ELSE

      l_usgm := Nm3sdo.get_theme_metadata( p_nth.nth_theme_id );

      l_diminfo := l_usgm.diminfo;
      l_srid    := l_usgm.srid;
     
    END IF;

    IF p_nth.nth_base_table_theme IS NOT NULL THEN

      BEGIN
        l_base_lyr := get_layer_by_theme(  p_nth.nth_base_table_theme );
        if l_base_lyr.layer_id is null then
          raise no_data_found;
        end if;
--          
      EXCEPTION
        WHEN OTHERS THEN
          retval.base_layer_id := 0;
          retval.srid          := register_SRID_from_theme( p_nth.nth_theme_id, l_base, l_srid );
      END;
--    no need to try and find an appropriate srid - use the base table

      if l_base_lyr.srid is not null and l_base_lyr.layer_id > 0 then
      
        retval.srid          := l_base_lyr.srid;
        retval.base_layer_id := l_base_lyr.layer_id;
        
      end if;

    ELSE
      retval.srid          := register_SRID_from_theme( p_nth.nth_theme_id, l_base, l_srid );
      retval.base_layer_id := 0;

    END IF;

    retval.LAYER_ID           := get_next_sde_layer;
    retval.DESCRIPTION        := p_nth.nth_theme_name;
    retval.DATABASE_NAME      := NULL;
    retval.OWNER              := Sys_Context('NM3CORE','APPLICATION_OWNER');
    retval.TABLE_NAME         := p_nth.nth_feature_table;
    retval.SPATIAL_COLUMN     := p_nth.nth_feature_shape_column;
    retval.EFLAGS             := convert_to_sde_eflag( Nm3sdo.get_theme_gtype( p_nth.nth_theme_id ) );
    retval.LAYER_MASK         := 0;
    retval.GSIZE1             := 0;
    retval.GSIZE2             := 0;
    retval.GSIZE3             := 0;
    retval.MINX               := l_diminfo(1).sdo_lb;
    retval.MINY               := l_diminfo(2).sdo_lb;
    retval.MAXX               := l_diminfo(1).sdo_ub;
    retval.MAXY               := l_diminfo(2).sdo_ub;
    retval.CDATE              := get_date_for_sde;
    retval.LAYER_CONFIG       := g_keyword;
    retval.OPTIMAL_ARRAY_SIZE := NULL;
    retval.STATS_DATE         := NULL;
    retval.MINIMUM_ID         := 1;


    RETURN retval;
END;
--
---------------------------------------------------------------------------------------------------------------
--

FUNCTION register_srid_from_theme( p_theme_id IN nm_themes_all.nth_theme_id%TYPE,
                                   p_base     IN nm_theme_array,
                                   p_srid     IN NUMBER ) RETURN NUMBER IS

  l_mbr          mdsys.sdo_geometry;
  l_sref         sref_record_t;
  l_base_srid    NUMBER;
  retval         NUMBER;
  l_length_unit  NUMBER;
  l_munits       NUMBER;
  l_gtype        NUMBER;

  cursor c_srid ( c_theme_id in nm_themes_all.nth_theme_id%type,
                  c_base     in nm_theme_array,
                  c_srid     in number,
                  c_munits   in number,
                  c_owner    in varchar2,
                  c_gtype    in number ) is
  select distinct r.srid
  from sde.layers l,
       nm_themes_all,
       nm_base_themes,
       table ( c_base.nta_theme_array ) t,
       user_sdo_geom_metadata m,
       sde.spatial_references r
  where nbth_base_theme = t.nthe_id
  and nth_theme_id = nbth_theme_id
  and l.table_name = nth_feature_table
  and l.table_name = m.table_name
  and m.column_name = l.spatial_column
  and nvl(m.srid, -999) = nvl(c_srid, -999)
  and l.srid = r.srid
  and owner = c_owner
  and decode( c_gtype,  3302, nvl(c_munits, -999),
                        3002, nvl(c_munits, -999),
                              nvl(c_munits, -999 )) = nvl(munits, -999 );

  FUNCTION get_length_unit_from_theme ( pi_nth_theme_id IN nm_themes_all.nth_theme_id%TYPE )
    RETURN nm_units.un_unit_id%TYPE
  IS
    retval nm_units.un_unit_id%TYPE;
  BEGIN
    SELECT nt_length_unit INTO retval
      FROM v_nm_net_themes_all
         , nm_types
     WHERE vnnt_nth_theme_id = pi_nth_theme_id
       AND vnnt_nt_type = nt_type
    UNION ALL
    SELECT nt_length_unit
      FROM nm_inv_themes,
           nm_types,
           nm_inv_nw
     WHERE nin_nit_inv_code = nith_nit_id
       AND nith_nth_theme_id = pi_nth_theme_id
       AND nin_nw_type = nt_type
       AND rownum = 1;

    RETURN retval;
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN RETURN NULL;
  END get_length_unit_from_theme;
--
BEGIN

  l_gtype  := Nm3sdo.get_theme_gtype( p_theme_id);

  if l_gtype in ( 3302, 3002) then

    l_length_unit := get_length_unit_from_theme( p_theme_id );

    l_munits := POWER ( 10, nm3unit.get_rounding(nm3unit.get_tol_from_unit_mask(nvl(l_length_unit, 1))));

  else

    l_munits := 1; --null;

  end if;

  open c_srid( p_theme_id,
               p_base,
               p_srid,
               l_munits,
               Sys_Context('NM3CORE','APPLICATION_OWNER'),
               l_gtype );

  fetch c_srid into retval;

  if c_srid%notfound then
    close c_srid;
    raise no_data_found;
  end if;

  close c_srid;
 
  return retval;

exception

  when no_data_found then
--
     l_mbr := Nm3sdo.get_theme_mbr( p_theme_id );

     l_sref.srid          := get_next_srid;
     l_sref.falsex        := l_mbr.sdo_ordinates(1);
     l_sref.falsey        := l_mbr.sdo_ordinates(2);
     l_sref.xyunits       := Get_Xyunits(Nm3sdo.Get_Theme_Diminfo(p_theme_id));
     l_sref.falsez        := 0;
     l_sref.zunits        := 1;
     l_sref.falsem        := 0;

     l_sref.munits        := l_munits;

     l_sref.srtext        := get_srtext(p_theme_id, p_base);

     l_sref.description   := NULL;
     l_sref.auth_name     := NULL;
     l_sref.auth_srid     := NULL;

     l_sref.object_flags  := 0;

--   needs to retrieve the spatial reference ID for the table, possibly by entering a new SRID record.

	 retval := get_srid_by_origin( l_sref );

     IF retval IS NULL THEN

       sde.sref_util.insert_spatial_references( l_sref );

       retval := l_sref.srid;

     END IF;

   RETURN retval;

end register_srid_from_theme;

--
---------------------------------------------------------------------------------------------------------------
--

FUNCTION get_srid_by_origin( p_sref IN sref_record_t ) RETURN NUMBER IS
--
--SRIDs should be consistent in the use of:
-- 1 origin - this could be critical to rounding so they must be close
-- 2 xyunits - this can be calculated unreliably, so again, as long as they are close
-- 3 munits -
-- 4 SRTEXT
-- auth_srid - this is not critical - especially with Oracle srids as long as the base layers hold the same oracle srid - so we
-- can ignore this.


CURSOR c1( c_falsex IN NUMBER,
           c_falsey IN NUMBER,
           c_xyunits IN NUMBER,
           c_munits   IN NUMBER,
           c_srtext IN VARCHAR2) IS
  SELECT srid
  FROM sde.spatial_references
  WHERE falsex = c_falsex
  AND   falsey = c_falsey
  AND   xyunits = c_xyunits
  AND   munits  = c_munits;

retval NUMBER := NULL;

BEGIN
--don't use the srtext yet
  OPEN c1( p_sref.falsex,
           p_sref.falsey,
           p_sref.xyunits,
           p_sref.munits,
           p_sref.srtext );

  FETCH c1 INTO retval;
  IF c1%NOTFOUND THEN
    retval := NULL;
  END IF;

  CLOSE c1;

  RETURN retval;
END;

--
---------------------------------------------------------------------------------------------------------------
--

FUNCTION get_layer( p_layer_id IN sde.layers.layer_id%TYPE ) RETURN layer_record_t IS

CURSOR c_layer( c_layer IN sde.layers.layer_id%TYPE ) IS
  SELECT *
  FROM sde.layers
  WHERE layer_id = c_layer;

l_layer layer_record_t;

BEGIN

  OPEN c_layer (p_layer_id );
  FETCH c_layer INTO l_layer;
  IF c_layer%NOTFOUND THEN
      CLOSE c_layer;
      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                   ,pi_id                 => 254
                   ,pi_sqlcode            => -20001
                   );
--    raise_application_error( -20001, 'Layer not found in SDE metadata');
  END IF;
  CLOSE c_layer;

  RETURN l_layer;

END;

--
---------------------------------------------------------------------------------------------------------------
--

FUNCTION get_layer_by_theme( p_theme_id IN NUMBER ) RETURN layer_record_t IS

l_nth NM_THEMES_ALL%ROWTYPE;

CURSOR c_layer( c_table IN VARCHAR2, c_column IN VARCHAR2 ) IS
  SELECT *
  FROM sde.layers
  WHERE table_name = c_table
  AND   spatial_column = c_column
  AND   owner = Sys_Context('NM3CORE','APPLICATION_OWNER');

l_layer layer_record_t;

BEGIN

  l_nth := Nm3get.get_nth( p_theme_id);

  OPEN c_layer (l_nth.nth_feature_table, l_nth.nth_feature_shape_column );
  FETCH c_layer INTO l_layer;
  IF c_layer%NOTFOUND THEN
      CLOSE c_layer;
      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                   ,pi_id                 => 254
                   ,pi_sqlcode            => -20001
                   );
--    raise_application_error( -20001, 'Layer not found in SDE metadata');
  END IF;
  CLOSE c_layer;

  RETURN l_layer;

END;

--
---------------------------------------------------------------------------------------------------------------
--

FUNCTION get_layer( p_table IN VARCHAR2, p_column IN VARCHAR2 )  RETURN layer_record_t IS

CURSOR c_layer( c_table IN VARCHAR2, c_column IN VARCHAR2) IS
  SELECT *
  FROM sde.layers
  WHERE table_name = c_table
  AND   spatial_column = c_column
  AND   owner = Sys_Context('NM3CORE','APPLICATION_OWNER');

l_layer layer_record_t;

BEGIN

  OPEN c_layer (p_table, p_column);
  FETCH c_layer INTO l_layer;
  IF c_layer%NOTFOUND THEN
      CLOSE c_layer;
      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                   ,pi_id                 => 254
                   ,pi_sqlcode            => -20001
                   );
--    raise_application_error( -20001, 'Layer not found in SDE metadata');
  END IF;
  CLOSE c_layer;

  RETURN l_layer;

END;

--
---------------------------------------------------------------------------------------------------------------
--

FUNCTION get_geocol( p_table IN VARCHAR2, p_column IN VARCHAR2 )  RETURN geocol_record_t  IS

CURSOR c_geocol( c_table IN VARCHAR2, c_column IN VARCHAR2) IS
  SELECT *
  FROM sde.geometry_columns
  WHERE f_table_schema = Sys_Context('NM3CORE','APPLICATION_OWNER')
  AND   f_table_name = c_table
  AND   f_geometry_column = c_column;


l_geocol geocol_record_t;

BEGIN

  OPEN c_geocol (p_table, p_column);
  FETCH c_geocol INTO l_geocol;
  IF c_geocol%NOTFOUND THEN
      CLOSE c_geocol;
      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                   ,pi_id                 => 254
                   ,pi_sqlcode            => -20001
                   );
--    raise_application_error( -20001, 'Layer not found in SDE metadata');
  END IF;
  CLOSE c_geocol;

  RETURN l_geocol;

END;


--
---------------------------------------------------------------------------------------------------------------
--
FUNCTION get_treg( p_table IN VARCHAR2 )  RETURN registration_record_t  IS

CURSOR c_treg( c_table IN VARCHAR2) IS
  SELECT *
  FROM sde.table_registry
  WHERE owner = Sys_Context('NM3CORE','APPLICATION_OWNER')
  AND   table_name = c_table;

l_treg registration_record_t;

BEGIN

  OPEN c_treg (p_table);
  FETCH c_treg INTO l_treg;
  IF c_treg%NOTFOUND THEN
      CLOSE c_treg;
      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                   ,pi_id                 => 254
                   ,pi_sqlcode            => -20001
                   );
--    raise_application_error( -20001, 'Layer not found in SDE metadata');
  END IF;
  CLOSE c_treg;

  RETURN l_treg;

END;


--
---------------------------------------------------------------------------------------------------------------
--
PROCEDURE drop_layer_by_theme( p_theme_id IN NUMBER ) IS

l_nth   NM_THEMES_ALL%ROWTYPE;

BEGIN

  l_nth := Nm3get.get_nth( p_theme_id );

  drop_layer_by_table ( l_nth.nth_feature_table, l_nth.nth_feature_shape_column );

END;

--
---------------------------------------------------------------------------------------------------------------
--


PROCEDURE drop_layer_by_table( p_table IN VARCHAR2, p_column IN VARCHAR2 ) IS

l_layer layer_record_t;

BEGIN

  l_layer := get_layer( p_table, p_column );

  Drop_Layer( l_layer.layer_id );

END;

--
---------------------------------------------------------------------------------------------------------------
--

PROCEDURE Drop_Layer( p_layer IN sde.layers.layer_id%TYPE ) IS

sde_reg_id sde.table_registry.REGISTRATION_ID%TYPE;

CURSOR c_get_sref( c_layer IN sde.layers.layer_id%TYPE, c_srid IN sde.layers.srid%TYPE ) IS
  SELECT COUNT(*)
  FROM sde.layers
  WHERE srid = c_srid
  AND layer_id != c_layer;

l_layer layer_record_t;

srid_count INTEGER;
--
--  Extracted from SDE api and removed owner check
--
  PROCEDURE delete_registration
               ( p_layer IN sde.layers.layer_id%TYPE )
  IS
  BEGIN
  --
    DELETE FROM sde.column_registry
    WHERE  (owner,table_name) IN
             (SELECT owner,table_name
              FROM   sde.table_registry
              WHERE  registration_id = p_layer);

    DELETE FROM sde.table_registry WHERE registration_id = p_layer;

    DELETE FROM sde.mvtables_modified WHERE registration_id = p_layer;
  --
  END delete_registration;
--
--  Extracted from SDE api and removed owner check
--
  PROCEDURE delete_layer
               ( p_layer IN sde.layers.layer_id%TYPE )
  IS
  BEGIN
    -- Delete the geometry_columns.

    DELETE FROM sde.geometry_columns WHERE
      (f_table_schema, f_table_name, f_geometry_column) =
        (SELECT owner, table_name,spatial_column FROM
           sde.layers WHERE layer_id = p_layer);

    -- Make sure that something was deleted.

    IF SQL%NOTFOUND THEN
      raise_application_error (-20501,--sde_util.SE_GEOMETRYCOL_NOEXIST,
                              'GEOMETRY_COLUMNS entry not found. ');
    END IF;

   -- Delete the layers.

    DELETE FROM sde.layers WHERE layer_id = p_layer;

   -- Since we've gotten this far without an exception, it must be OK
   -- to commit.
   COMMIT;
  END delete_layer;
--
BEGIN

  l_layer := get_layer( p_layer );
--
  OPEN get_registry (l_layer.table_name);
  FETCH get_registry INTO sde_reg_id;

  IF get_registry%FOUND THEN
     --sde.REGISTRY_UTIL.delete_registration(sde_reg_id);
     delete_registration (sde_reg_id);
  END IF;

  CLOSE get_registry;
--
  OPEN  c_get_sref( l_layer.layer_id, l_layer.srid );
  FETCH c_get_sref INTO srid_count;
  CLOSE c_get_sref;

--  sde.LAYERS_UTIL.delete_layer(l_layer.layer_id);
  delete_layer (l_layer.layer_id);

-- remove_column_registry( l_layer.table_name );

  IF srid_count = 0 THEN
    sde.sref_util.delete_spatial_references (l_layer.srid);
  END IF;

END drop_layer;

--
---------------------------------------------------------------------------------------------------------------
--

FUNCTION convert_to_sde_eflag(gtype IN INTEGER, lrs_override IN VARCHAR2 DEFAULT 'Y') RETURN INTEGER IS
   eflag INTEGER;
   sub_typ INTEGER;
   m_dim INTEGER;
   dim  INTEGER;

   l_gtype  INTEGER := gtype;
BEGIN
   eflag := -1;
   IF gtype < 0
   THEN
     RETURN eflag;
   END IF;

   IF lrs_override = 'Y' AND gtype = 3002 THEN
     l_gtype := 3302;
   END IF;

   -- ORACLE SPATIAL

   eflag := SE_STORAGE_SPATIAL_TYPE;

   -- assume gtype is of Oracle 9 character

   dim := TRUNC(l_gtype/1000);
   sub_typ := MOD(l_gtype,10);
   m_dim := TRUNC(MOD(l_gtype,1000)/100);

-- if sub_typ > 4 sub_typ := sub_typ - 4; ???
   IF sub_typ = 1  -- point
   THEN
     eflag := eflag + SE_POINT_TYPE_MASK;
   ELSIF sub_typ = 5  -- multi point
   THEN
     eflag := eflag + SE_POINT_TYPE_MASK + SE_MULTIPART_TYPE_MASK;
   ELSIF sub_typ = 2  -- line (simple)
   THEN
     eflag := eflag + SE_SIMPLE_LINE_TYPE_MASK;
   ELSIF sub_typ = 6  -- multi line
   THEN
     eflag := eflag + SE_LINE_TYPE_MASK + SE_MULTIPART_TYPE_MASK;
   ELSIF sub_typ = 3  -- polygon
   THEN
     eflag := eflag + SE_AREA_TYPE_MASK;
   ELSIF sub_typ = 7  -- multi polygon
   THEN
     eflag := eflag + SE_AREA_TYPE_MASK + SE_MULTIPART_TYPE_MASK;
   END IF;

   IF dim = 3
   THEN
      IF m_dim = 0
      THEN
        eflag := eflag + SE_LAYER_16; -- Z values
      ELSE
        eflag := eflag + SE_LAYER_19; -- M values
      END IF;
   ELSIF dim = 4
   THEN
      -- assume m_dim [ 3|4 ]
      eflag := eflag + SE_LAYER_16 + SE_LAYER_19;
   END IF;

   RETURN eflag;
END;

--
---------------------------------------------------------------------------------------------------------------
--

FUNCTION get_sde_date( p_date IN INTEGER) RETURN DATE IS
   retval DATE;
BEGIN
-- 24 * 60 * 60 = 86400

  SELECT TO_DATE('01/01/1970 00:00:00','DD/MM/YYYY hh24:mi:ss') + p_date/86400
  INTO retval
  FROM dual;

  RETURN retval;

EXCEPTION
   WHEN OTHERS THEN
      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                   ,pi_id                 => 255
                   ,pi_sqlcode            => -20001
                   );
--     raise_application_error(-20001, 'Failure in SDE date conversion');
   RETURN TRUNC(SYSDATE);
END;

--
---------------------------------------------------------------------------------------------------------------
--

FUNCTION get_date_for_sde( p_date IN DATE DEFAULT TRUNC(SYSDATE) ) RETURN INTEGER IS
retval INTEGER;
BEGIN
-- 24 * 60 * 60 = 86400

  SELECT ((p_date - TO_DATE('01/01/1970 00:00:00','DD/MM/YYYY hh24:mi:ss')) * 86400)
  INTO retval
  FROM dual;

  IF retval IS NULL
  THEN
     RETURN 1039510652;
  END IF;
  RETURN retval;
EXCEPTION
   WHEN OTHERS THEN
      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                   ,pi_id                 => 256
                   ,pi_sqlcode            => -20001
                   );
--   raise_application_error(-20001, 'Failure in date conversion to SDE');
--   return 1039510652;
END;
--
---------------------------------------------------------------------------------------------------------------
--
FUNCTION  get_sde_type_from_gtype( p_gtype IN INTEGER, p_allow_multi IN VARCHAR2 DEFAULT 'N') RETURN INTEGER IS

   rt       INTEGER;
   dim  INTEGER;
   res  INTEGER;

BEGIN
   rt := -1;

   IF p_gtype < 0
   THEN
     RETURN -1;
   END IF;

   res := Nm3sdo.get_type_from_gtype(p_gtype);

   IF res = 1 THEN
     rt := 1; -- point
     IF p_allow_multi = 'Y' THEN
       rt := 5;
     END IF;
   ELSIF res = 2 THEN
     rt := 3; -- linestring
     IF p_allow_multi = 'Y' THEN
       rt := 9; -- multilinestring
     END IF;
   ELSIF res = 3 THEN
     rt := 5; -- polygon
     IF p_allow_multi = 'Y' THEN
       rt := 11; -- multipolygon
     END IF;
   ELSIF res = 4 THEN
     rt := 6; -- collection
   ELSIF res = 5 THEN
     rt := 7; -- multipoint
   ELSIF res = 6 THEN
     rt := 9; -- multilinestring
   ELSIF res = 7 THEN
     rt := 11; -- multipolygon
   END IF;
-- We don't want to deal with curves and the like
   RETURN rt;
END;

--
---------------------------------------------------------------------------------------------------------------
--

PROCEDURE regenerate_sde_from_themes IS

-- get all tables that need to be registered

CURSOR c_nth_tab IS
  SELECT nth_theme_id
  FROM NM_THEMES_ALL
  WHERE nth_theme_type = 'SDO'
  AND nth_feature_table IS NOT NULL
  AND EXISTS ( SELECT 1 FROM all_tab_columns
               WHERE table_name = nth_feature_table
               AND   column_name = nth_feature_shape_column
               AND owner = Sys_Context('NM3CORE','APPLICATION_OWNER'))
  AND nth_base_table_theme IS NULL
  AND NOT EXISTS
    ( SELECT 1
      FROM sde.layers
      WHERE table_name = nth_feature_table
      AND   owner      = Sys_Context('NM3CORE','APPLICATION_OWNER') );

CURSOR c_nth_view IS
  SELECT nth_theme_id, nth_base_table_theme
  FROM NM_THEMES_ALL
  WHERE nth_theme_type = 'SDO'
  AND nth_feature_table IS NOT NULL
  AND nth_base_table_theme IS NOT NULL
  AND EXISTS ( SELECT 1 FROM all_tab_columns
               WHERE table_name = nth_feature_table
               AND   column_name = nth_feature_shape_column
               AND owner = Sys_Context('NM3CORE','APPLICATION_OWNER'))
  AND NOT EXISTS
    ( SELECT 1
      FROM sde.layers
      WHERE table_name = nth_feature_table
      AND   owner      = Sys_Context('NM3CORE','APPLICATION_OWNER') );


BEGIN

--Loop over all base tables and register them in sde

  FOR irec IN c_nth_tab LOOP

    register_sde_layer ( irec.nth_theme_id );

  END LOOP;

--Now put all the other table and view data in there, using the table as a template

  FOR irec IN c_nth_view LOOP

    register_sde_layer( p_theme_id => irec.nth_theme_id );

  END LOOP;

END;

--
---------------------------------------------------------------------------------------------------------------
--

PROCEDURE create_column_registry (
   p_table    IN   VARCHAR2,
   p_column   IN   VARCHAR2,
   p_rowid    IN   VARCHAR2
)
IS
--
   SUBTYPE layer_record_t IS sde.layers%ROWTYPE;
--
--1 = SE_INT16_TYPE             2-byte Integer
--2 = SE_INT32_TYPE             4-byte Integer
--3 = SE_FLOAT32_TYPE           4-byte Float
--4 = SE_FLOAT64_TYPE           8-byte Float
--5 = SE_STRING_TYPE            Null Term. Character Array
--6 = SE_BLOB_TYPE              Variable Length Data
--7 = SE_DATE_TYPE              Struct tm Date
--8 = SE_SHAPE_TYPE             Shape geometry (SE_SHAPE)
--9 = SE_RASTER_TYPE            Raster
--10 = SE_XML_TYPE              XML Document
--11 = SE_INT64_TYPE            8-byte Integer
--12 = SE_UUID_TYPE             A Universal Unique ID
--13 = SE_CLOB_TYPE             Character variable length data
--14 = SE_NSTRING_TYPE UNICODE  Null Term. Character Array
--15 = SE_NCLOB_TYPE UNICODE    Character Large Object
--
   CURSOR c1 (c_table IN VARCHAR2)
   IS
      SELECT column_name,
             DECODE (data_type,
                     'DATE', 7,
                     'VARCHAR2', 5,
                     'CHAR', 5,
                     'NUMBER', 4,
                     'INTEGER', 2,
                     'SDO_GEOMETRY', 8
                    ),
             data_length, data_precision, data_scale, nullable
        FROM user_tab_columns
       WHERE table_name = c_table;

--
   CURSOR c2 (c_table IN VARCHAR2)
   IS
      SELECT a.column_name
        FROM user_cons_columns a, user_constraints b
       WHERE a.constraint_name = b.constraint_name
         AND b.table_name = c_table
         AND b.constraint_type IN ('P', 'U')
      UNION
      SELECT a.column_name
        FROM user_ind_columns a, user_indexes b
       WHERE a.index_name = b.index_name
         AND b.table_name = c_table
         AND b.uniqueness = 'UNIQUE';

--
   l_col_tab              nm3type.tab_varchar30;
   l_data_type_tab        nm3type.tab_varchar30;
   l_data_length_tab      nm3type.tab_number;
   l_data_precision_tab   nm3type.tab_number;
   l_data_scale_tab       nm3type.tab_number;
   l_nullable_tab         nm3type.tab_varchar1;

   l_obj_id               INTEGER;
   l_obj_flag             NUMBER;
   l_pk_col               VARCHAR2 (30);
   l_layer                layer_record_t;
--
BEGIN
--
   OPEN c1 (p_table);
   FETCH c1
   BULK COLLECT INTO l_col_tab, l_data_type_tab, l_data_length_tab,
                     l_data_precision_tab, l_data_scale_tab, l_nullable_tab;
   CLOSE c1;

--assume single column unique key or primary key or unique index?
   OPEN c2 (p_table);
   FETCH c2
    INTO l_pk_col;
   CLOSE c2;
--
   l_layer := get_layer (p_table, p_column);
--
   FOR i IN 1 .. l_col_tab.COUNT
   LOOP
      IF l_col_tab (i) = p_column
      THEN
         l_data_precision_tab (i) := NULL;
         l_data_length_tab (i) := NULL;
         l_obj_id := l_layer.layer_id;
         l_obj_flag := 131076;
      ELSE
         l_obj_id := NULL;

         IF l_col_tab (i) = l_pk_col
         THEN
            l_obj_flag := 3;
         ELSE
            l_obj_flag := 4;
         END IF;
      --
         IF l_data_type_tab (i) = 4 AND l_data_scale_tab (i) = 0
         THEN

     -- cater here for integer columns or number(38) or integer number columns
     -- integer - set length only

            IF l_data_precision_tab (i) = 38
            THEN                                 -- this is an integer column
               l_data_type_tab (i) := 2;
               l_data_length_tab (i) := 10;
               l_data_precision_tab (i) := NULL;
            ELSIF l_data_length_tab (i) = 22
              AND l_data_precision_tab (i) IS NOT NULL
            THEN        -- integer disguised a fixed length number with no dp.
               l_data_type_tab (i) := 2;
               l_data_length_tab (i) := l_data_precision_tab (i);
               l_data_precision_tab (i) := NULL;
            ELSIF l_data_length_tab (i) = 22
              AND l_data_precision_tab (i) IS NULL
            THEN                                   -- this is a generic number
         --      l_data_type_tab (i) := 3; -- CWS 0109471 NO NEED TO CHANGE AN 8 BIT TO A 4 BIT. THIS CAUSES ISSUES
               l_data_length_tab (i) := 0;
               l_data_precision_tab (i) := 0;
            END IF;
      --
         ELSIF l_data_type_tab (i) = 4
           AND l_data_length_tab (i) = 22
           AND l_data_precision_tab (i) IS NULL
           AND l_data_scale_tab (i) IS NULL
         THEN                                      -- this is a generic number
         --   l_data_type_tab (i) := 3; -- CWS 0109471 NO NEED TO CHANGE AN 8 BIT TO A 4 BIT. THIS CAUSES ISSUES
            l_data_length_tab (i) := 0;
            l_data_precision_tab (i) := 0;
      --
      --------------------------------------------------------------------------
      -- AE  19-FEB-2009
      -- Quick fix for SDE 9.1
      -- Ensure any number with precision and scale is set to an SDE_TYPE of 3
      --
         ELSIF l_data_type_tab (i) = 4
           AND l_data_precision_tab (i) > 0
           AND l_data_scale_tab (i) > 0
           AND nm3sde.get_sde_version = '9.1'
         THEN                                   -- this is a number with scale
          --
         --   l_data_type_tab (i)      := 3; -- CWS 0109471 NO NEED TO CHANGE AN 8 BIT TO A 4 BIT. THIS CAUSES ISSUES
            l_data_length_tab (i)    := l_data_precision_tab (i);
            l_data_precision_tab (i) := l_data_scale_tab (i);
          --
      --
      -- AE  19-FEB-2009
      -- End of changes
      --------------------------------------------------------------------------
      --
         ELSIF l_data_type_tab (i) = 4
         THEN
            l_data_length_tab (i) := l_data_scale_tab (i);
            l_data_precision_tab (i) := l_data_scale_tab (i);
      --
         ELSIF l_data_type_tab (i) = 7
         THEN
            l_data_length_tab (i) := 0;
         END IF;
      --
         IF l_nullable_tab (i) = 'N'
         THEN
            l_obj_flag := 0;
         ELSE
            l_obj_flag := 4;
         END IF;
      --
         IF l_col_tab (i) = p_rowid
         THEN
            l_obj_flag := 3;
         END IF;
   --
      END IF;

--    execute immediate '
      INSERT INTO sde.column_registry
                  ( table_name
                  , owner
                  , column_name
                  , sde_type
                  , column_size
                  , decimal_digits
                  , description
                  , object_flags
                  , object_id
                  )
           VALUES ( p_table
                  , Sys_Context('NM3CORE','APPLICATION_OWNER')
                  , l_col_tab (i)
                  , l_data_type_tab (i)
                  , l_data_length_tab (i)
                  , l_data_precision_tab (i) --l_data_scale(i)
                  , NULL
                  , l_obj_flag
                  , l_obj_id
                  );
   END LOOP;
--
END create_column_registry;
--
---------------------------------------------------------------------------------------------------------------
--
PROCEDURE remove_column_registry(p_table IN VARCHAR2 )  IS
BEGIN
--
  EXECUTE IMMEDIATE ' delete from sde.column_registry '||
                    '  where table_name = :table '||
                    '  and   owner = Sys_Context(''NM3CORE'',''APPLICATION_OWNER'') ' USING p_table;
--
END;
--
---------------------------------------------------------------------------------------------------------------
--
FUNCTION Get_Xyunits( p_diminfo IN mdsys.sdo_dim_array ) RETURN NUMBER IS
mintol NUMBER;
BEGIN
  mintol := LEAST( p_diminfo(1).sdo_tolerance, p_diminfo(2).sdo_tolerance);
  RETURN  GREATEST( 1/mintol, 1);
END;
/*
  retval     NUMBER;
  diffs      NUMBER;
  maxxyunits NUMBER := 2147483648;
BEGIN
  diffs   := LEAST( ( p_diminfo(1).sdo_ub - p_diminfo(1).sdo_lb), ( p_diminfo(2).sdo_ub - p_diminfo(2).sdo_lb));
  diffs   := GREATEST( 1, diffs);
  retval  := TRUNC( maxxyunits/diffs );
  retval  := retval - MOD( retval, 10);
  RETURN   GREATEST(retval,1);
END;
*/
--
---------------------------------------------------------------------------------------------------------------
--
/*
FUNCTION Get_Xyunits( p_layer_id IN sde.layers.layer_id%TYPE) RETURN NUMBER IS
l_layer  layer_record_t := get_layer( p_layer_id );
BEGIN
  RETURN Get_Xyunits( l_layer.minx, l_layer.maxx, l_layer.miny, l_layer.maxy );
END;
*/
--
---------------------------------------------------------------------------------------------------------------
--
/*
FUNCTION Get_Xyunits( xmin IN NUMBER, xmax IN NUMBER, ymin IN NUMBER, ymax IN NUMBER ) RETURN NUMBER IS
  retval     NUMBER;
  diffs      NUMBER;
  maxxyunits NUMBER := 2147483648;
BEGIN
  diffs   := LEAST( ( xmax - xmin), ( ymax - ymin));
  diffs   := GREATEST( 1, diffs);
  retval  := TRUNC( maxxyunits/diffs );
  retval  := retval - MOD( retval, 10);
  RETURN   GREATEST(retval,1);
END;
*/
--
---------------------------------------------------------------------------------------------------------------
--

PROCEDURE drop_sub_layer_by_table
/*
   This procedure is used to remove subordinate user SDE metadata. It works in two
   modes -
      i. Trigger on nm_theme_roles will call this in a loop to remove all SDE
         data for a given table and column.
     ii. Trigger on hig_user_roles will call this for a given user to clear out
         all SDE data for the role revoked - derived from nm_theme_roles
*/
           ( p_table    IN   VARCHAR2
           , p_column   IN   VARCHAR2
           , p_owner    IN   VARCHAR2 DEFAULT NULL)
IS
   CURSOR c_layer (c_table  IN VARCHAR2
                 , c_column IN VARCHAR2)
   IS
      SELECT layer_id, owner
        FROM sde.layers, HIG_USERS
       WHERE owner = hus_username
         AND owner != Sys_Context('NM3CORE','APPLICATION_OWNER')
         AND table_name = c_table
         AND spatial_column = c_column;

   CURSOR c_layer2 ( c_table  IN VARCHAR2
                    ,c_column IN VARCHAR2
                    ,c_owner  IN VARCHAR2)
   IS
      SELECT layer_id
        FROM sde.layers
       WHERE table_name = c_table
         AND spatial_column = c_column
         AND owner = c_owner;

   l_layer_id PLS_INTEGER;
--
BEGIN
--
-- AE 19-June-2008
-- Added call to del_creg to remove column_registry

   IF p_owner IS NOT NULL
   THEN
      OPEN c_layer2 (p_table, p_column, p_owner);
      FETCH c_layer2 INTO l_layer_id;
      IF c_layer2%FOUND
      THEN
         CLOSE c_layer2;
         del_layer (l_layer_id);
         del_gcol (p_table, p_column, p_owner);
         del_treg (p_table, p_owner);
         del_creg (p_table, p_owner);
      ELSE
         CLOSE c_layer2;
      END IF;
   ELSE
      FOR irec IN c_layer (p_table, p_column)
      LOOP
         del_layer (irec.layer_id);
         del_gcol (p_table, p_column, irec.owner);
         del_treg (p_table, irec.owner);
         del_creg (p_table, irec.owner);
      END LOOP;
   END IF;
--
END;
--


PROCEDURE del_gcol( p_table IN VARCHAR2, p_column IN VARCHAR2, p_owner IN VARCHAR2)  IS

BEGIN

  DELETE
  FROM sde.geometry_columns
  WHERE f_table_name = p_table
  AND   f_geometry_column = p_column
  AND   f_table_schema = p_owner;

EXCEPTION
  WHEN NO_DATA_FOUND THEN NULL;
END;

-----------------------------------------------------------------------------------------

PROCEDURE del_treg( p_table IN VARCHAR2, p_owner IN VARCHAR2)  IS

BEGIN

  DELETE
  FROM sde.table_registry
  WHERE table_name = p_table
  AND   owner = p_owner;

EXCEPTION
  WHEN NO_DATA_FOUND THEN NULL;
END;

-----------------------------------------------------------------------------------------

PROCEDURE del_layer( p_layer IN NUMBER )  IS

BEGIN

  DELETE
  FROM sde.layers
  WHERE layer_id = p_layer;

EXCEPTION
  WHEN NO_DATA_FOUND THEN NULL;
END;

-----------------------------------------------------------------------------------------

PROCEDURE del_creg( p_table IN VARCHAR2, p_owner IN VARCHAR2)  IS

BEGIN

  DELETE
  FROM sde.column_registry
  WHERE table_name = p_table
  AND   owner = p_owner;

EXCEPTION
  WHEN NO_DATA_FOUND THEN NULL;
END;

-----------------------------------------------------------------------------------------
/*

FUNCTION get_keyword RETURN VARCHAR2 IS
retval VARCHAR2(32);
BEGIN
  SELECT keyword
  INTO retval
  FROM sde.dbtune
  WHERE CONFIG_STRING='SDO_GEOMETRY';

  RETURN retval;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR( -20001, 'Keyword not available' );
  WHEN TOO_MANY_ROWS THEN
    RAISE_APPLICATION_ERROR( -20001, 'Too many Keywords' );
END;
*/
----------------------------------------------------------------------------------------------
---
PROCEDURE copy_sde_obj_from_theme( p_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE,
                                   p_theme_usr IN HIG_USER_ROLES.HUR_USERNAME%TYPE
                                 ) IS
--
  l_layer  layer_record_t;
  l_geocol geocol_record_t;
  l_reg    registration_record_t;
--
  TYPE             tab_col_reg
  IS TABLE OF sde.column_registry%ROWTYPE INDEX BY BINARY_INTEGER;
--
  l_tab_col_reg    tab_col_reg;
--
  CURSOR get_col_reg ( c_table      IN VARCHAR2
                     , c_for_owner  IN VARCHAR2)
  IS
    SELECT table_name, c_for_owner, column_name, sde_type
         , column_size, decimal_digits
         , description, object_flags, object_id
      FROM sde.column_registry a
     WHERE a.owner = Sys_Context('NM3CORE','APPLICATION_OWNER')
       AND a.table_name = c_table
       AND NOT EXISTS
         (SELECT 1 FROM sde.column_registry b
           WHERE b.owner = c_for_owner
             AND b.table_name = a.table_name
             AND b.column_name = a.column_name );

--
  PRAGMA   autonomous_transaction;
--
BEGIN

  -- Clone the layer record
  l_layer           := get_layer_by_theme( p_theme_id );
  l_layer.owner     := p_theme_usr;
  l_layer.layer_id  := get_next_sde_layer;

  -- Clone the geometry columns record
  l_geocol                := get_geocol( l_layer.table_name, l_layer.spatial_column );
  l_geocol.f_table_schema := p_theme_usr;

  -- Insert the new layer and geometry_columns records
  -- note that the last parameter is unused
  sde.layers_util.insert_layer( l_layer, l_geocol, l_layer.table_name );


  -- Clone the Table registry record
  -- sde.table_registry
  l_reg := get_treg( l_layer.table_name );
  l_reg.owner:= p_theme_usr;
  l_reg.registration_id := get_next_sde_table_id;

  -- Insert the table registry record
  sde.registry_util.insert_registration( l_reg );

  -- AE 19 June 2008
  -- Create the column registry
  --
--  create_sub_column_registry
--    ( p_table    => l_layer.table_name,
--      p_owner    => p_theme_usr );

  OPEN  get_col_reg (l_layer.table_name, p_theme_usr);
  FETCH get_col_reg BULK COLLECT INTO l_tab_col_reg;
  CLOSE get_col_reg;
--
  IF l_tab_col_reg.COUNT > 0
  THEN
    FORALL i IN 1..l_tab_col_reg.COUNT
      INSERT INTO sde.column_registry
      VALUES l_tab_col_reg(i);
  END IF;

  COMMIT;
EXCEPTION
  WHEN OTHERS THEN ROLLBACK; NULL;
--EXCEPTION
--   WHEN NO_DATA_FOUND THEN NULL;
--   WHEN OTHERS THEN RAISE;
END;
-----------------------------------------------------------------------------------------

--
  PROCEDURE create_sub_sde_layer
              (p_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE
              ,p_username IN HIG_USERS.HUS_USERNAME%TYPE) IS

  l_nth NM_THEMES_ALL%ROWTYPE;

  l_layer  layer_record_t;
  l_geocol geocol_record_t;
  l_reg    registration_record_t;
  l_sde_cnt NUMBER;

  BEGIN

  l_nth := Nm3get.get_nth( p_theme_id );

     SELECT COUNT(*)
     INTO l_sde_cnt
     FROM sde.layers
     WHERE table_name = l_nth.nth_feature_table
     AND   owner = p_username;

     IF l_sde_cnt > 0 THEN
       NULL;
     --Nm_Debug.DEBUG ('Multiple layers with same feature name');
     ELSE

      --Nm_Debug.DEBUG ('Leaving Create_sde_lyr_theme_by_user');

      copy_sde_obj_from_theme( p_theme_id  => p_theme_id,
                               p_theme_usr => p_username
                             );

      END IF;
  END;



-----------------------------------------------------------------------------------------

FUNCTION Get_Whole_Shape_Objectids ( p_theme_id IN NUMBER, p_id_array IN int_array ) RETURN int_array IS

l_nth NM_THEMES_ALL%ROWTYPE := Nm3get.get_nth( p_theme_id );
l_bas NM_THEMES_ALL%ROWTYPE := l_nth;
l_reg sde.table_registry%ROWTYPE := Nm3sde.get_treg(l_nth.nth_feature_table);

cur_str VARCHAR2(2000);

retval int_array := int_array(int_array_type( NULL ));

geocur Nm3type.ref_cursor;

l_base NM_THEMES_ALL%ROWTYPE;

FUNCTION join_int_array( p_nth IN NM_THEMES_ALL%ROWTYPE, p_ia IN int_array ) RETURN int_array IS
  curstr VARCHAR2(4000);
  retval int_array := int_array( int_array_type( NULL ));
BEGIN
  curstr := 'select /*cardinality( t '||to_char(p_ia.ia.last)||')*/ t.column_value from table ( :p_ia.ia ) t, '||p_nth.nth_feature_table||
            ' where t.column_value  = '||l_reg.rowid_column;

--nm_debug.debug_on;
--nm_debug.debug( curstr );

  EXECUTE IMMEDIATE curstr BULK COLLECT INTO retval.ia USING p_ia;

  RETURN retval;
END join_int_array;


BEGIN

  IF l_bas.nth_base_table_theme IS NOT NULL THEN

      l_nth := Nm3get.get_nth( l_nth.nth_base_table_theme );

  END IF;

--     cur_str := 'select f1.'||l_reg.rowid_column||
--                ' from '||l_nth.nth_feature_table||' f1, table ( :p_id.ia ) i where f1.'||l_nth.nth_feature_pk_column||' in '||
--         ' ( select f2.'||l_nth.nth_feature_pk_column||' from '||l_nth.nth_feature_table||' f2 '||
--       ' where f2.'||l_reg.rowid_column||' = i.column_value )';

    cur_str := 'select DISTINCT f1.'||l_reg.rowid_column||
               ' from '||l_nth.nth_feature_table||' f1, '||l_nth.nth_feature_table||' f2 where f1.'||l_nth.nth_feature_pk_column||' = '||
        ' f2.'||l_nth.nth_feature_pk_column||' and f2.'||l_reg.rowid_column||' in ( select column_value from table( :b_int_array ))';


  --Nm_Debug.debug_on;

--  Nm_Debug.DEBUG(cur_str);

  OPEN geocur FOR cur_str using p_id_array.ia;
  FETCH geocur BULK COLLECT INTO retval.ia;
  CLOSE geocur;

  IF l_bas.nth_base_table_theme IS NOT NULL THEN

    retval := join_int_array( l_bas, retval );

  END IF;

  RETURN retval;

END Get_Whole_Shape_Objectids;

--
-------------------------------------------------------------------------------------------------------------------------------
--

FUNCTION get_sde_pk (p_nth IN nm_themes_all%ROWTYPE)
   RETURN VARCHAR2
IS
   retval   VARCHAR2 (30) := p_nth.nth_feature_pk_column;
BEGIN
   IF p_nth.nth_feature_pk_column = 'OBJECTID'
   THEN
      retval := 'OBJECTID';
   ELSE
      BEGIN
         SELECT column_name
           INTO retval
           FROM user_tab_columns
          WHERE table_name = p_nth.nth_feature_table
            AND data_type = 'NUMBER'
            AND (   (    column_name = 'OBJECTID'
                     AND data_scale = 0
                     AND data_precision = 38
                    )
                 OR (    data_precision IS NULL
                     AND data_length = 22
                     AND data_scale = 0
                    )
                );
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            retval := p_nth.nth_feature_pk_column;
         WHEN TOO_MANY_ROWS
         THEN
            BEGIN
               SELECT t.column_name
                 INTO retval
                 FROM user_tab_columns t,
                      user_cons_columns cc,
                      user_constraints c
                WHERE t.table_name = p_nth.nth_feature_table
                  AND t.table_name = c.table_name
                  AND c.constraint_type IN ('P', 'U')
                  AND c.constraint_name = cc.constraint_name
                  AND cc.column_name = t.column_name
                  AND cc.POSITION = 1
                  AND data_type = 'NUMBER'
                  AND (   (    t.column_name = 'OBJECTID'
                           AND data_scale = 0
                           AND data_precision = 38
                          )
                       OR (    data_precision IS NULL
                           AND data_length = 22
                           AND data_scale = 0
                          )
                      );
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  SELECT t.column_name
                    INTO retval
                    FROM user_tab_columns t,
                         user_ind_columns cc,
                         user_indexes c
                   WHERE t.table_name = p_nth.nth_feature_table
                     AND t.table_name = c.table_name
                     AND c.uniqueness = 'UNIQUE'
                     AND c.index_name = cc.index_name
                     AND cc.column_name = t.column_name
                     AND cc.column_position = 1
                     AND data_type = 'NUMBER'
                     AND (   (    t.column_name = 'OBJECTID'
                              AND data_scale = 0
                              AND data_precision = 38
                             )
                          OR (    data_precision IS NULL
                              AND data_length = 22
                              AND data_scale = 0
                             )
                         );
            END;
         WHEN OTHERS
         THEN
            retval := p_nth.nth_feature_pk_column;
      END;
   END IF;

   RETURN retval;
END get_sde_pk;
--
-------------------------------------------------------------------------------------------------------------------------------
--
FUNCTION get_srtext ( p_theme_id in NM_THEMES_ALL.nth_theme_id%TYPE, p_base in nm_theme_array ) RETURN varchar2 IS

cursor c1 ( c_theme_id in NM_THEMES_ALL.nth_theme_id%TYPE ) is
  select srtext from sde.spatial_references r, sde.layers l, user_sdo_geom_metadata a, user_sdo_geom_metadata b, nm_themes_all t
  where nth_theme_id = c_theme_id
  and a.table_name = nth_feature_table
  and nvl(b.srid, -999) = nvl(a.srid, -999)
  and b.table_name = l.table_name
  and l.srid = r.srid
  and l.owner = Sys_Context('NM3_SECURITY_CTX','USERNAME')
  group by srtext;

curstr NM3TYPE.MAX_VARCHAR2 := 'select substr(definition, 1, 1024) '
                              ||' from sde.st_coordinate_systems r, user_sdo_geom_metadata b, nm_themes_all t '
                              ||'  where nth_theme_id = :theme_id '
                              ||'  and b.table_name = nth_feature_table '
                              ||'  and b.srid = r.id and rownum = 1';

l_version varchar2(30) := NM3SDE.GET_SDE_VERSION;

retval sde.spatial_references.srtext%TYPE;
-- CWS 0111258 Changes made so that 9.2 and 9.3 versions uses the
-- spatial_references table in the event there is no record in
-- st_coordinate_systems
BEGIN
  IF l_version IN ('9.2' ,'9.3')
  THEN
    BEGIN
--    nm_debug.debug('get srtext from primary theme');

      EXECUTE IMMEDIATE curstr INTO retval USING p_theme_id;
    EXCEPTION
      WHEN others THEN
        if p_base.nta_theme_array.last is not null then

		  begin
  		    EXECUTE IMMEDIATE curstr INTO retval USING p_base.nta_theme_array(1).nthe_id;
		  exception
		    when no_data_found then
			  retval := null;
		  end;
        else       
          retval := NULL;
		  
		end if;
    END;
  END IF;

  IF retval IS NULL
  THEN
    OPEN c1( p_theme_id );
    FETCH c1 INTO retval;
    --
    IF c1%NOTFOUND THEN
      retval := 'UNKNOWN';
    END IF;
    --
    CLOSE c1;
  END IF;
  RETURN retval;

END get_srtext;
--
-------------------------------------------------------------------------------------------------------------------------------
--
PROCEDURE debug_layer ( p_layer IN sde.layers%ROWTYPE ) IS
BEGIN
  Nm_Debug.DEBUG( 'LAYER_ID '||TO_CHAR( p_layer.LAYER_ID ));
  Nm_Debug.DEBUG( 'DESCRIPTION '|| p_layer.DESCRIPTION );
  Nm_Debug.DEBUG( 'DATABASE_NAME '|| p_layer.DATABASE_NAME );
  Nm_Debug.DEBUG( 'OWNER '|| p_layer.OWNER );
  Nm_Debug.DEBUG( 'TABLE_NAME '|| p_layer.TABLE_NAME );
  Nm_Debug.DEBUG( 'SPATIAL_COLUMN '|| p_layer.SPATIAL_COLUMN );
  Nm_Debug.DEBUG( 'EFLAGS '||TO_CHAR( p_layer.EFLAGS ));
  Nm_Debug.DEBUG( 'LAYER_MASK '||TO_CHAR( p_layer.LAYER_MASK ));
  Nm_Debug.DEBUG( 'GSIZE1 '||TO_CHAR( p_layer.GSIZE1 ));
  Nm_Debug.DEBUG( 'GSIZE2 '||TO_CHAR( p_layer.GSIZE2 ));
  Nm_Debug.DEBUG( 'GSIZE3 '||TO_CHAR( p_layer.GSIZE3 ));
  Nm_Debug.DEBUG( 'MINX '||TO_CHAR( p_layer.MINX ));
  Nm_Debug.DEBUG( 'MINY '||TO_CHAR( p_layer.MINY ));
  Nm_Debug.DEBUG( 'MAXX '||TO_CHAR( p_layer.MAXX ));
  Nm_Debug.DEBUG( 'MAXY '||TO_CHAR( p_layer.MAXY ));
  Nm_Debug.DEBUG( 'CDATE '||TO_CHAR( p_layer.CDATE ));
  Nm_Debug.DEBUG( 'LAYER_CONFIG '|| p_layer.LAYER_CONFIG );
  Nm_Debug.DEBUG( 'OPTIMAL_ARRAY_SIZE '||TO_CHAR( p_layer.OPTIMAL_ARRAY_SIZE ));
  Nm_Debug.DEBUG( 'STATS_DATE '||TO_CHAR( p_layer.STATS_DATE ));
  Nm_Debug.DEBUG( 'MINIMUM_ID '||TO_CHAR( p_layer.MINIMUM_ID ));
  Nm_Debug.DEBUG( 'SRID '||TO_CHAR( p_layer.SRID ));
  Nm_Debug.DEBUG( 'BASE_LAYER_ID'||TO_CHAR( p_layer.BASE_LAYER_ID));
END debug_layer;
END;
/
