CREATE OR REPLACE PACKAGE BODY nm3sdo_util
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3sdo_util.pkb-arc   1.1   Jan 16 2010 00:17:00   rcoupe  $
--       Module Name      : $Workfile:   nm3sdo_util.pkb  $
--       Date into PVCS   : $Date:   Jan 16 2010 00:17:00  $
--       Date fetched Out : $Modtime:   Jan 16 2010 00:14:52  $
--       Version          : $Revision:   1.1  $
--       Based on SCCS version :
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   1.1  $';

  g_package_name CONSTANT varchar2(30) := 'nm3sdo_util';
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
PROCEDURE reshape_route (
   gis_session_id IN gis_data_objects.gdo_session_id%TYPE)
IS
   l_ne   NUMBER;
BEGIN
   SELECT ne_id
     INTO l_ne
     FROM nm_elements_all, gis_data_objects
    WHERE ne_id = gdo_pk_id AND gdo_session_id = gis_session_id;

   BEGIN
      NM3SDM.RESHAPE_ROUTE (l_ne, nm3user.get_effective_date, 'Y');
   END;
END reshape_route;
--
-----------------------------------------------------------------------------
--
PROCEDURE reverse_datum (
   gis_session_id IN gis_data_objects.gdo_session_id%TYPE)
IS
   l_ne       nm_elements.ne_id%TYPE;
   l_length   NUMBER;
   l_shape    MDSYS.sdo_geometry;
   feature_table NM_THEMES_ALL.NTH_FEATURE_TABLE%type;
   pk_column  NM_THEMES_ALL.NTH_FEATURE_PK_COLUMN%type;
   theme_id   nm_themes_all.nth_theme_id%type;

   CURSOR c1 is
   select distinct nth_feature_table, nth_feature_pk_column, nth_theme_id
    from gis_data_objects, nm_themes_all, nm_nw_themes, nm_linear_types, nm_nodes, nm_types
    where gdo_session_id = gis_session_id
    and nlt_g_i_d = 'D'
    and nlt_id = nnth_nlt_id
    and nnth_nth_theme_id = nth_theme_id
    and no_node_type = nt_node_type
    and nlt_nt_type = nt_type
    and nth_base_table_theme is null;

BEGIN

    OPEN c1;
    FETCH c1 INTO feature_table, pk_column, theme_id;
    CLOSE c1;

EXECUTE IMMEDIATE
     'SELECT ne_id, ne_length, shape ' ||
     'FROM gis_data_objects, nm_elements, ' || feature_table || ' ' ||
     'WHERE gdo_session_id = '|| gis_session_id  ||
     'AND ne_id = gdo_pk_id ' ||
     'AND '||pk_column||' = ne_id ' INTO l_ne, l_length, l_shape;


EXECUTE IMMEDIATE
    'UPDATE ' || feature_table || ' ' ||
    'SET shape = NM3SDO.REVERSE_GEOMETRY (:l_shape, 0) ' ||
    'WHERE ' || pk_column || ' = '|| l_ne using l_shape;

   NM3SDO.CHANGE_AFFECTED_SHAPES (theme_id, l_ne);
END reverse_datum;
--
-----------------------------------------------------------------------------
--
END nm3sdo_util;
/
